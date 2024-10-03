import 'package:rent_n_trace/features/auth/domain/entity/user.dart';

sealed class UserState {}

final class UserInitial extends UserState {}

final class UserAuthenticated extends UserState {
  final User user;
  UserAuthenticated(this.user);
}

final class UserUnauthenticated extends UserState {}
