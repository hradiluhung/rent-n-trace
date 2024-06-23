part of 'driver_bloc.dart';

@immutable
sealed class DriverEvent {}

final class DriverGetAvailableDrivers extends DriverEvent {}
