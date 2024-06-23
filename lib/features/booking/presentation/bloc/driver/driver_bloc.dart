import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/driver.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/drivers/get_available_drivers.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final GetAvailableDrivers _getAvailableDrivers;

  DriverBloc({
    required GetAvailableDrivers getAvailableDrivers,
  })  : _getAvailableDrivers = getAvailableDrivers,
        super(DriverInitial()) {
    on<DriverEvent>((event, emit) => emit(DriverLoading()));
    on<DriverGetAvailableDrivers>(_onGetAvailableDrivers);
  }

  void _onGetAvailableDrivers(
      DriverGetAvailableDrivers event, Emitter<DriverState> emit) async {
    final res = await _getAvailableDrivers(NoParams());

    res.fold(
      (failure) => emit(DriverFailure(failure.message)),
      (drivers) {
        emit(DriverGetDriversSuccess(drivers));
      },
    );
  }
}
