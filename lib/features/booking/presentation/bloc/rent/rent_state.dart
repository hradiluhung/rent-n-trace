part of 'rent_bloc.dart';

@immutable
sealed class RentState {
  const RentState();
}

final class RentInitial extends RentState {}

final class RentLoading extends RentState {}

final class RentMultipleRentsLoaded extends RentState {
  final List<Rent> rents;
  const RentMultipleRentsLoaded(this.rents);
}

final class RentLatestRentLoaded extends RentState {
  final Rent rent;
  const RentLatestRentLoaded(this.rent);
}

final class RentAllRentStatsLoaded extends RentState {
  final List<Rent> rents;
  final Rent? latestRent;

  const RentAllRentStatsLoaded({
    required this.rents,
    required this.latestRent,
  });
}

final class RentFailure extends RentState {
  final String message;
  const RentFailure(this.message);
}

final class RentCreateRentSuccess extends RentState {
  final Rent rent;
  const RentCreateRentSuccess(this.rent);
}

final class RentUpdateRentSuccess extends RentState {
  final String message;
  const RentUpdateRentSuccess(this.message);
}
