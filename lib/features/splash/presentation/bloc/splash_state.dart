import 'package:rent_n_trace/features/auth/domain/entity/user.dart';

sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashAuthenticated extends SplashState {
  final User user;
  SplashAuthenticated(this.user);
}

final class SplashUnauthenticated extends SplashState {}
