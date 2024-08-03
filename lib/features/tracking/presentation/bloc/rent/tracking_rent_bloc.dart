import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/get_rent_by_id.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/update_fuel_consumption.dart';

part 'tracking_rent_event.dart';
part 'tracking_rent_state.dart';

class TrackingRentBloc extends Bloc<TrackingRentEvent, TrackingRentState> {
  final GetRentById _getRentById;
  final UpdateFuelConsumption _updateFuelConsumption;

  TrackingRentBloc({
    required GetRentById getRentById,
    required UpdateFuelConsumption updateFuelConsumption,
  })  : _getRentById = getRentById,
        _updateFuelConsumption = updateFuelConsumption,
        super(TrackingRentInitial()) {
    on<TrackingRentEvent>((event, emit) => emit(TrackingRentLoading()));
    on<TrackingRentGetByRentIdEvent>(_getRentByRentIdEvent);
    on<TrackingRentUpdateFuelEvent>(_updateFuel);
  }

  void _getRentByRentIdEvent(
      TrackingRentGetByRentIdEvent event, Emitter<TrackingRentState> emit) async {
    final result = await _getRentById(GetRentByIdParams(rentId: event.rentId));

    result.fold((failure) => emit(TrackingRentFailure(failure.message)),
        (rent) => emit(TrackingRentGetSuccess(rent)));
  }

  void _updateFuel(TrackingRentUpdateFuelEvent event, Emitter<TrackingRentState> emit) async {
    final result = await _updateFuelConsumption(
        UpdateFuelConsumptionParams(rentId: event.rentId, fuelConsumption: event.fuelConsumption));

    result.fold(
      (failure) => emit(TrackingRentFailure(failure.message)),
      (rent) => emit(TrackingRentUpdateSuccess(rent)),
    );
  }
}
