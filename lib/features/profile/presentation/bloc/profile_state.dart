part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);
}

final class ProfileUpdateSuccess extends ProfileState {
  final User user;
  const ProfileUpdateSuccess(this.user);
}
