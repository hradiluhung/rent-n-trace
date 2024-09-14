import 'package:rent_n_trace/features/car/domain/entity/car.dart';

sealed class DisplayAllCarsState {}

class DisplayCarsLoading extends DisplayAllCarsState {}

class DisplayCarsLoaded extends DisplayAllCarsState {
  final List<Car> cars;

  DisplayCarsLoaded({
    required this.cars,
  });
}

class DisplayCarsFailed extends DisplayAllCarsState {
  final String message;

  DisplayCarsFailed({required this.message});
}
