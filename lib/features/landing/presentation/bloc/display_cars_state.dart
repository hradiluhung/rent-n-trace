import 'package:rent_n_trace/features/car/domain/entity/car.dart';

sealed class DisplayCarsState {}

class DisplayCarsLoading extends DisplayCarsState {}

class DisplayCarsLoaded extends DisplayCarsState {
  final List<Car> cars;

  DisplayCarsLoaded({
    required this.cars,
  });
}

class DisplayCarsFailed extends DisplayCarsState {
  final String message;

  DisplayCarsFailed({required this.message}); 
}
