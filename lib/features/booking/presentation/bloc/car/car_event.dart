part of 'car_bloc.dart';

@immutable
sealed class CarEvent {}

class CarGetAvailableCars extends CarEvent {
  final DateTime startDatetime;
  final DateTime endDatetime;

  CarGetAvailableCars({
    required this.startDatetime,
    required this.endDatetime,
  });
}

class CarGetNotAvailableCars extends CarEvent {
  final DateTime startDatetime;
  final DateTime endDatetime;

  CarGetNotAvailableCars({
    required this.startDatetime,
    required this.endDatetime,
  });
}

class CarGetAllAvailabilityCars extends CarEvent {
  final DateTime startDatetime;
  final DateTime endDatetime;

  CarGetAllAvailabilityCars({
    required this.startDatetime,
    required this.endDatetime,
  });
}

class CarGetAllCars extends CarEvent {}
