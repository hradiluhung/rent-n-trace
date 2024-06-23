part of 'rent_bloc.dart';

@immutable
sealed class RentState {
  const RentState();
}

final class RentInitial extends RentState {}

final class RentLoading extends RentState {}

final class RentGetRentsSuccess extends RentState {
  final List<Rent> rents;
  const RentGetRentsSuccess(this.rents);
}

final class RentGetLatestRentSuccess extends RentState {
  final Rent rent;
  const RentGetLatestRentSuccess(this.rent);
}

final class RentGetAllStatsRentSuccess extends RentState {
  final List<Rent> rents;
  final Rent? latestRent;

  const RentGetAllStatsRentSuccess({
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
