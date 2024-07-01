part of 'location_bloc.dart';

@immutable
sealed class LocationState {
  const LocationState();
}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationGetLocationSuccess extends LocationState {
  final Stream<Location> realTimeLocation;

  const LocationGetLocationSuccess(this.realTimeLocation);
}

final class LocationFailure extends LocationState {
  final String message;

  const LocationFailure(this.message);
}
