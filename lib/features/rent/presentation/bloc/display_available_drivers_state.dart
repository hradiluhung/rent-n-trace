import 'package:rent_n_trace/features/driver/domain/entity/driver.dart';

sealed class DisplayAvailableDriversState {}

class DisplayDriversLoading extends DisplayAvailableDriversState {}

class DisplayDriversLoaded extends DisplayAvailableDriversState {
  final List<Driver> drivers;
  DisplayDriversLoaded(this.drivers);
}

class DisplayDriversFailed extends DisplayAvailableDriversState {
  final String message;
  DisplayDriversFailed(this.message);
}
