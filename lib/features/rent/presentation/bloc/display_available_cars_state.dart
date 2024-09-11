import 'package:rent_n_trace/features/car/domain/entity/car.dart';

sealed class DisplayAvailableCarsState {}

class DisplayCarsLoading extends DisplayAvailableCarsState {}

class DisplayCarsLoaded extends DisplayAvailableCarsState {
  final List<Car> cars;
  DisplayCarsLoaded(this.cars);
}

class DisplayCarsFailed extends DisplayAvailableCarsState {
  final String message;
  DisplayCarsFailed(this.message);
}
