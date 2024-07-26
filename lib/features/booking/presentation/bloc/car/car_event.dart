part of 'car_bloc.dart';

@immutable
sealed class CarEvent {}

class GetAvailableCarsEvent extends CarEvent {
  final DateTime startDatetime;
  final DateTime endDatetime;

  GetAvailableCarsEvent({
    required this.startDatetime,
    required this.endDatetime,
  });
}

class GetNotAvailableCarsEvent extends CarEvent {
  final DateTime startDatetime;
  final DateTime endDatetime;

  GetNotAvailableCarsEvent({
    required this.startDatetime,
    required this.endDatetime,
  });
}

class GetAllAvailabilityCarsEvent extends CarEvent {
  final DateTime startDatetime;
  final DateTime endDatetime;

  GetAllAvailabilityCarsEvent({
    required this.startDatetime,
    required this.endDatetime,
  });
}

class GetAllCarsEvent extends CarEvent {}
