part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccessAuth extends AuthState {
  final User user;

  const AuthSuccessAuth(this.user);
}

final class AuthSuccessLoginWithGoogle extends AuthState {}

final class AuthSuccessLogout extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}
