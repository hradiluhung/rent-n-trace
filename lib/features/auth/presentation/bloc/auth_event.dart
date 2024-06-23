part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String fullName;
  final String password;

  AuthSignUp({
    required this.email,
    required this.fullName,
    required this.password,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthLoginGoogle extends AuthEvent {}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthLogout extends AuthEvent {}
