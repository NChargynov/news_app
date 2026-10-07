import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/auth/ui/bloc/auth_cubit.dart';
import 'package:news_app/features/auth/ui/presentation/auth_page.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';
import 'package:news_app/main.dart';

import '../news/support/news_fixture.dart';
import 'support/auth_fixture.dart';

Future<void> _fillForm(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).first, ' reader ');
  await tester.enterText(find.byType(TextFormField).last, ' test-password ');
}

Future<void> _pumpAuth(
  WidgetTester tester,
  FakeAuthRepository repository, {
  VoidCallback? onAuthenticated,
  Size size = const Size(375, 812),
  double scale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: BlocProvider(
        create: (_) => AuthCubit(repository: repository),
        child: AuthPage(onAuthenticated: onAuthenticated ?? () {}),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Montserrat')
      ..addFont(
        rootBundle.load('assets/fonts/montserrat/Montserrat-Variable.ttf'),
      );
    await loader.load();
  });

  testWidgets('пустая форма не вызывает запрос авторизации', (tester) async {
    final repository = FakeAuthRepository(() async => true);
    await _pumpAuth(tester, repository);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(repository.calls, isEmpty);
    expect(find.text('Введите логин'), findsNWidgets(2));
    expect(find.text('Введите пароль'), findsNWidgets(2));
  });

  testWidgets('пароль скрывается и показывается без изменения значения', (
    tester,
  ) async {
    await _pumpAuth(tester, FakeAuthRepository(() async => true));
    await _fillForm(tester);
    TextField password() =>
        tester.widgetList<TextField>(find.byType(TextField)).last;
    expect(password().obscureText, isTrue);
    await tester.tap(find.byTooltip('Показать пароль'));
    await tester.pump();
    expect(password().obscureText, isFalse);
    expect(password().controller!.text, ' test-password ');
    await tester.tap(find.byTooltip('Скрыть пароль'));
    await tester.pump();
    expect(password().obscureText, isTrue);
  });

  testWidgets('загрузка блокирует повторный вход и сохраняет пробелы пароля', (
    tester,
  ) async {
    final response = Completer<bool>();
    final repository = FakeAuthRepository(() => response.future);
    var successes = 0;
    await _pumpAuth(tester, repository, onAuthenticated: () => successes++);
    await _fillForm(tester);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(
      tester
          .widgetList<TextField>(find.byType(TextField))
          .every((field) => field.enabled == false),
      isTrue,
    );
    expect(repository.calls, [('reader', ' test-password ')]);
    response.complete(true);
    await tester.pumpAndSettle();
    expect(successes, 1);
  });

  testWidgets('ошибка остаётся на форме и позволяет повторить вход', (
    tester,
  ) async {
    var success = false;
    var successes = 0;
    final repository = FakeAuthRepository(() async => success);
    await _pumpAuth(tester, repository, onAuthenticated: () => successes++);
    await _fillForm(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(
      find.text('Ошибка авторизации. Проверьте логин и пароль.'),
      findsOneWidget,
    );
    expect(successes, 0);
    success = true;
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(successes, 1);
    expect(repository.calls, hasLength(2));
  });

  testWidgets(
    'узкий экран, крупный шрифт и клавиатура не вызывают переполнения',
    (tester) async {
      await _pumpAuth(
        tester,
        FakeAuthRepository(() async => false),
        size: const Size(320, 568),
        scale: 2,
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      addTearDown(tester.view.resetViewInsets);
      await _fillForm(tester);
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.byType(FilledButton).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'приложение открывает вход первым и загружает новости только после успеха',
    (tester) async {
      final auth = FakeAuthRepository(() async => true);
      final news = FakeNewsRepository(newsFixture(3));
      await getIt.reset();
      addTearDown(() => getIt.reset());
      getIt.registerFactory<AuthCubit>(() => AuthCubit(repository: auth));
      getIt.registerFactory<NewsBloc>(() => NewsBloc(newsRepository: news));
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.byType(AuthPage), findsOneWidget);
      expect(news.requests, 0);
      await _fillForm(tester);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(AuthPage), findsNothing);
      expect(news.requests, 1);
      expect(
        tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
