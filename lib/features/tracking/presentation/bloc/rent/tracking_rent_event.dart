part of 'tracking_rent_bloc.dart';

@immutable
sealed class TrackingRentEvent {
  const TrackingRentEvent();
}

class TrackingRentGetByRentIdEvent extends TrackingRentEvent {
  final String rentId;

  const TrackingRentGetByRentIdEvent(this.rentId);
}
