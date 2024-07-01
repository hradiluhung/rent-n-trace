part of 'rent_bloc.dart';

@immutable
sealed class RentEvent {}

final class RentGetCurrentMonthRent extends RentEvent {
  final String userId;

  RentGetCurrentMonthRent({
    required this.userId,
  });
}

final class RentGetApprovedOrTrackedRent extends RentEvent {
  final String userId;

  RentGetApprovedOrTrackedRent({
    required this.userId,
  });
}

final class RentGetAllStatsRent extends RentEvent {
  final String userId;

  RentGetAllStatsRent({
    required this.userId,
  });
}

final class RentCreateRent extends RentEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final String need;
  final String needDetail;
  final String? driverId;
  final String? driverName;
  final String? carId;
  final String? carName;

  RentCreateRent({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.need,
    required this.needDetail,
    this.driverId,
    this.driverName,
    this.carId,
    this.carName,
  });
}

final class RentUpdateCancelRent extends RentEvent {
  final String rentId;

  RentUpdateCancelRent({
    required this.rentId,
  });
}

final class RentGetAllUserRents extends RentEvent {
  final String userId;

  RentGetAllUserRents({
    required this.userId,
  });
}
