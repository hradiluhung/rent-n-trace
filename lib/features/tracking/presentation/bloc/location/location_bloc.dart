import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/tracking/domain/entities/location.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/get_location.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocation _getLocation;

  LocationBloc({
    required GetLocation getLocation,
  })  : _getLocation = getLocation,
        super(LocationInitial()) {
    on<LocationEvent>((event, emit) => emit(LocationLoading()));
    on<LocationGetRealTimeLocation>(_onGetRealTimeLocation);
  }

  void _onGetRealTimeLocation(
      LocationGetRealTimeLocation event, Emitter<LocationState> emit) async {
    final res = await _getLocation(event.rentId);

    res.fold(
      (failure) => emit(LocationFailure(failure.message)),
      (realTimeLocation) => emit(LocationGetLocationSuccess(realTimeLocation)),
    );
  }
}
