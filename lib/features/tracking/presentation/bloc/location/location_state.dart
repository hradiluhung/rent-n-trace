part of 'location_bloc.dart';

@immutable
sealed class LocationState {
  const LocationState();
}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationFailure extends LocationState {
  final String message;

  const LocationFailure(this.message);
}

final class LocationUpdateSuccess extends LocationState {
  final String message;

  const LocationUpdateSuccess(this.message);
}
