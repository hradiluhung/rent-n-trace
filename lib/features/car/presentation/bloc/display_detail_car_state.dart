import 'package:rent_n_trace/features/car/domain/entity/car.dart';

sealed class DisplayDetailCarState {}

class DisplayDetailCarStateLoading extends DisplayDetailCarState {}

class DisplayDetailCarStateLoaded extends DisplayDetailCarState {
  final Car car;
  DisplayDetailCarStateLoaded(this.car);
}

class DisplayDetailCarStateFailed extends DisplayDetailCarState {
  final String message;
  DisplayDetailCarStateFailed(this.message);
}
