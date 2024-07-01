part of 'car_bloc.dart';

@immutable
sealed class CarState {
  const CarState();
}

final class CarInitial extends CarState {}

final class CarLoading extends CarState {}

final class CarFailure extends CarState {
  final String message;
  const CarFailure(this.message);
}

final class CarAllCarsLoaded extends CarState {
  final List<Car> cars;
  const CarAllCarsLoaded(this.cars);
}

final class CarAvailableCarsLoaded extends CarState {
  final List<Car> cars;
  const CarAvailableCarsLoaded(this.cars);
}

final class CarNotAvailableCarsLoaded extends CarState {
  final List<Car> cars;
  const CarNotAvailableCarsLoaded(this.cars);
}

class CarAllAvailabilityCarsLoaded extends CarState {
  final List<Car> availableCars;
  final List<Car> notAvailableCars;

  const CarAllAvailabilityCarsLoaded({
    required this.availableCars,
    required this.notAvailableCars,
  });
}
