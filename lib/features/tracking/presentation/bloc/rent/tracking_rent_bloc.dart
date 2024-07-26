import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/get_rent_by_id.dart';

part 'tracking_rent_event.dart';
part 'tracking_rent_state.dart';

class TrackingRentBloc extends Bloc<TrackingRentEvent, TrackingRentState> {
  final GetRentById _getRentById;

  TrackingRentBloc({
    required GetRentById getRentById,
  })  : _getRentById = getRentById,
        super(TrackingRentInitial()) {
    on<TrackingRentEvent>((event, emit) => emit(TrackingRentLoading()));
    on<TrackingRentGetByRentIdEvent>(_getRentByRentIdEvent);
  }

  void _getRentByRentIdEvent(TrackingRentGetByRentIdEvent event, Emitter<TrackingRentState> emit) async {
    final result = await _getRentById(GetRentByIdParams(rentId: event.rentId));

    result.fold((failure) => emit(TrackingRentFailure(failure.message)), (rent) => emit(TrackingRentGetSuccess(rent)));
  }
}
