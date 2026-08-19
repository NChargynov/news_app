part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadingAuthState extends AuthState {}

final class ErrorAuthState extends AuthState {
  ErrorAuthState({required this.message});

  final String message;
}

final class SuccessAuthState extends AuthState {
  SuccessAuthState();
}
