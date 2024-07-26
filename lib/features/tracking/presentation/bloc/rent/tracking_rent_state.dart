part of 'tracking_rent_bloc.dart';

@immutable
sealed class TrackingRentState {
  const TrackingRentState();
}

final class TrackingRentInitial extends TrackingRentState {}

final class TrackingRentLoading extends TrackingRentState {}

final class TrackingRentFailure extends TrackingRentState {
  final String message;

  const TrackingRentFailure(this.message);
}

final class TrackingRentGetSuccess extends TrackingRentState {
  final Rent rent;
  const TrackingRentGetSuccess(this.rent);
}
