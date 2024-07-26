part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class UpdateUserProfileEvent extends ProfileEvent {
  final User user;
  final File? photo;

  UpdateUserProfileEvent(this.user, this.photo);
}
