import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/cars/get_all_cars.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/cars/get_available_cars.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/cars/get_not_available_cars.dart';

part 'car_event.dart';
part 'car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetAvailableCars _getAvailableCars;
  final GetNotAvailableCars _getNotAvailableCars;
  final GetAllCars _getAllCars;

  CarBloc({
    required GetAvailableCars getAvailableCars,
    required GetNotAvailableCars getNotAvailableCars,
    required GetAllCars getAllCars,
  })  : _getAvailableCars = getAvailableCars,
        _getNotAvailableCars = getNotAvailableCars,
        _getAllCars = getAllCars,
        super(CarInitial()) {
    on<CarEvent>((event, emit) => emit(CarLoading()));
    on<CarGetAvailableCars>(_onGetAvailableCars);
    on<CarGetNotAvailableCars>(_onGetNotAvailableCars);
    on<CarGetAllCars>(_onGetAllCars);
    on<CarGetAllAvailabilityCars>(_onGetAllAvailabilityCars);
  }

  void _onGetAvailableCars(
      CarGetAvailableCars event, Emitter<CarState> emit) async {
    final res = await _getAvailableCars(GetAvailableCarsParams(
      startDate: event.startDatetime,
      endDate: event.endDatetime,
    ));

    res.fold(
      (failure) => emit(CarFailure(failure.message)),
      (cars) => emit(CarGetAvailableSuccess(cars)),
    );
  }

  void _onGetNotAvailableCars(
      CarGetNotAvailableCars event, Emitter<CarState> emit) async {
    final res = await _getNotAvailableCars(GetNotAvailableCarsParams(
      startDate: event.startDatetime,
      endDate: event.endDatetime,
    ));

    res.fold(
      (failure) => emit(CarFailure(failure.message)),
      (cars) => emit(CarGetNotAvailableSuccess(cars)),
    );
  }

  void _onGetAllCars(CarGetAllCars event, Emitter<CarState> emit) async {
    final res = await _getAllCars(NoParams());

    res.fold(
      (failure) => emit(CarFailure(failure.message)),
      (cars) => emit(CarGetAllSuccess(cars)),
    );
  }

  void _onGetAllAvailabilityCars(
      CarGetAllAvailabilityCars event, Emitter<CarState> emit) async {
    final availableRes = await _getAvailableCars(GetAvailableCarsParams(
      startDate: event.startDatetime,
      endDate: event.endDatetime,
    ));

    final notAvailableRes =
        await _getNotAvailableCars(GetNotAvailableCarsParams(
      startDate: event.startDatetime,
      endDate: event.endDatetime,
    ));

    availableRes.fold(
      (failure) => emit(CarFailure(failure.message)),
      (availableCars) {
        notAvailableRes.fold(
          (failure) => emit(CarFailure(failure.message)),
          (notAvailableCars) {
            emit(
              CarGetAllAvailabilitySuccess(
                availableCars: availableCars,
                notAvailableCars: notAvailableCars,
              ),
            );
          },
        );
      },
    );
  }
}
