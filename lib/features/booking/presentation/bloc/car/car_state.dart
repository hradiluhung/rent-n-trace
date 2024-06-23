part of 'car_bloc.dart';

@immutable
sealed class CarState {
  const CarState();
}

final class CarInitial extends CarState {}

final class CarLoading extends CarState {}

final class CarGetAllSuccess extends CarState {
  final List<Car> cars;
  const CarGetAllSuccess(this.cars);
}

final class CarGetAvailableSuccess extends CarState {
  final List<Car> cars;
  const CarGetAvailableSuccess(this.cars);
}

final class CarGetNotAvailableSuccess extends CarState {
  final List<Car> cars;
  const CarGetNotAvailableSuccess(this.cars);
}

class CarGetAllAvailabilitySuccess extends CarState {
  final List<Car> availableCars;
  final List<Car> notAvailableCars;

  const CarGetAllAvailabilitySuccess({
    required this.availableCars,
    required this.notAvailableCars,
  });
}

final class CarFailure extends CarState {
  final String message;
  const CarFailure(this.message);
}
