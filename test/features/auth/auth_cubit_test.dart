import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/auth/ui/bloc/auth_cubit.dart';
import 'package:news_app/features/auth/ui/bloc/auth_state.dart';

import 'support/auth_fixture.dart';

void main() {
  test('успешный вход завершается успехом без последующей ошибки', () async {
    final cubit = AuthCubit(repository: FakeAuthRepository(() async => true));
    final states = <AuthState>[];
    final subscription = cubit.stream.listen(states.add);
    await cubit.auth('reader', 'test-password');
    await cubit.close();
    await subscription.cancel();
    expect(states, [isA<LoadingAuthState>(), isA<SuccessAuthState>()]);
  });

  test('отказ сервера позволяет повторить вход', () async {
    var success = false;
    final cubit = AuthCubit(
      repository: FakeAuthRepository(() async => success),
    );
    await cubit.auth('reader', 'test-password');
    expect(cubit.state, isA<ErrorAuthState>());
    success = true;
    await cubit.auth('reader', 'test-password');
    expect(cubit.state, isA<SuccessAuthState>());
    await cubit.close();
  });

  test('техническое исключение не выводится в сообщение формы', () async {
    final cubit = AuthCubit(
      repository: FakeAuthRepository(
        () async => throw StateError('internal response details'),
      ),
    );
    await cubit.auth('reader', 'test-password');
    expect(cubit.state, isA<ErrorAuthState>());
    expect(
      (cubit.state as ErrorAuthState).message,
      isNot(contains('internal response details')),
    );
    await cubit.close();
  });

  test('повторный запрос во время загрузки игнорируется', () async {
    final response = Completer<bool>();
    final repository = FakeAuthRepository(() => response.future);
    final cubit = AuthCubit(repository: repository);
    final request = cubit.auth('reader', 'test-password');
    final repeated = cubit.auth('reader', 'test-password');
    expect(repository.calls, hasLength(1));
    response.complete(true);
    await Future.wait([request, repeated]);
    await cubit.close();
  });

  test('завершение запроса после закрытия экрана безопасно', () async {
    final response = Completer<bool>();
    final cubit = AuthCubit(
      repository: FakeAuthRepository(() => response.future),
    );
    final request = cubit.auth('reader', 'test-password');
    await cubit.close();
    response.complete(true);
    await request;
  });
}
