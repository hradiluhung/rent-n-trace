part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {
  const LocationEvent();
}

class LocationGetRealTimeLocation extends LocationEvent {
  final String rentId;

  const LocationGetRealTimeLocation(this.rentId);
}
