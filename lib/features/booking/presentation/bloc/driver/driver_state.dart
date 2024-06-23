part of 'driver_bloc.dart';

@immutable
sealed class DriverState {
  const DriverState();
}

final class DriverInitial extends DriverState {}

final class DriverLoading extends DriverState {}

final class DriverGetDriversSuccess extends DriverState {
  final List<Driver>? drivers;

  const DriverGetDriversSuccess(this.drivers);
}

final class DriverFailure extends DriverState {
  final String message;

  const DriverFailure(this.message);
}
