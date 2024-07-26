part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {
  const LocationEvent();
}

class LocationStartTrackingEvent extends LocationEvent {
  final String rentId;
  final double latitude;
  final double longitude;

  const LocationStartTrackingEvent({
    required this.rentId,
    required this.latitude,
    required this.longitude,
  });
}

class LocationStopTrackingEvent extends LocationEvent {
  final String rentId;
  final List<LatLng> positions;
  final double distance;

  const LocationStopTrackingEvent({
    required this.rentId,
    required this.positions,
    required this.distance,
  });
}
