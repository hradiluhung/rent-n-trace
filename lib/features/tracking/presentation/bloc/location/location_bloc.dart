import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/start_tracking.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/stop_tracking.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final StartTracking _startTracking;
  final StopTracking _stopTracking;

  LocationBloc({
    required StartTracking startTracking,
    required StopTracking stopTracking,
  })  : _startTracking = startTracking,
        _stopTracking = stopTracking,
        super(LocationInitial()) {
    on<LocationEvent>((event, emit) => emit(LocationLoading()));
    on<LocationStartTrackingEvent>(_updateLocationEvent);
    on<LocationStopTrackingEvent>(_stopLocationEvent);
  }

  void _updateLocationEvent(
    LocationStartTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await _startTracking(
      StartTrackingParams(
        rentId: event.rentId,
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    result.fold(
      (failure) => emit(LocationFailure(failure.message)),
      (message) => emit(LocationUpdateSuccess(message)),
    );
  }

  void _stopLocationEvent(
    LocationStopTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await _stopTracking(
      StopTrackingParams(
        rentId: event.rentId,
        positions: event.positions,
        distance: event.distance,
      ),
    );

    result.fold(
      (failure) => emit(LocationFailure(failure.message)),
      (message) => emit(LocationUpdateSuccess(message)),
    );
  }
}
