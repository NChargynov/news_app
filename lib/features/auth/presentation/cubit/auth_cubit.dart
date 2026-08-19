import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/features/auth/domain/repo/auth_repository.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> auth(String login, String password) async {
    emit(LoadingAuthState());

    try {
      final result = await authRepository.auth(login, password);
      if (result) {
        emit(SuccessAuthState());
        return;
      }
      emit(ErrorAuthState(message: "Ошибка Авторизации"));
    } catch (e) {
      emit(ErrorAuthState(message: "Ошибка Авторизации ${e.toString()}"));
    }
  }
}
