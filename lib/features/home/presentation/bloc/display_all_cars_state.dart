import 'package:rent_n_trace/features/car/domain/entity/car.dart';

sealed class DisplayAllCarsState {}

class DisplayCarsLoading extends DisplayAllCarsState {
  final Car placeholder = Car(
    id: 'id',
    name: 'name',
    fuelConsumption: 'fuelConsumption',
    fuelType: 'fuelType',
    status: 'status',
    image: 'image',
  );
}

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
