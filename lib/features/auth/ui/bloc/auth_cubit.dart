import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/features/auth/domain/repo/auth_repo.dart';

import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository}) : super(AuthInitial());

  final AuthRepository repository;

  Future<void> auth(String login, String password) async {
    if (isClosed || state is LoadingAuthState) return;
    emit(LoadingAuthState());

    try {
      final result = await repository.auth(login, password);
      if (isClosed) return;
      if (result) {
        emit(SuccessAuthState());
        return;
      }
      emit(
        ErrorAuthState(
          message: 'Ошибка авторизации. Проверьте логин и пароль.',
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        ErrorAuthState(
          message: 'Не удалось выполнить вход. Попробуйте ещё раз.',
        ),
      );
    }
  }
}
