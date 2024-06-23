import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/create_rent.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/get_latest_rent.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/get_current_month_rents.dart';

part 'rent_event.dart';
part 'rent_state.dart';

class RentBloc extends Bloc<RentEvent, RentState> {
  final GetCurrentMonthRents _getCurrentMonthRent;
  final CreateRent _createRent;
  final GetLatestRent _getApprovedOrTrackedRent;

  RentBloc({
    required GetCurrentMonthRents getCurrentMonthRent,
    required CreateRent createRent,
    required GetLatestRent getApprovedOrTrackedRent,
  })  : _getCurrentMonthRent = getCurrentMonthRent,
        _createRent = createRent,
        _getApprovedOrTrackedRent = getApprovedOrTrackedRent,
        super(RentInitial()) {
    on<RentEvent>((event, emit) => emit(RentLoading()));
    on<RentGetAllStatsRent>(_onGetCurrentMonthRent);
    on<RentCreateRent>(_onCreateRent);
  }

  void _onCreateRent(RentCreateRent event, Emitter<RentState> emit) async {
    final res = await _createRent(CreateRentParams(
      userId: event.userId,
      startDate: event.startDate,
      endDate: event.endDate,
      destination: event.destination,
      need: event.need,
      needDetail: event.needDetail,
      driverId: event.driverId,
      driverName: event.driverName,
      carId: event.carId,
      carName: event.carName,
    ));

    res.fold(
      (failure) => emit(RentFailure(failure.message)),
      (rent) => emit(RentCreateRentSuccess(rent)),
    );
  }

  void _onGetCurrentMonthRent(
      RentGetAllStatsRent event, Emitter<RentState> emit) async {
    final currentMonthRes =
        await _getCurrentMonthRent(GetCurrentMonthRentsParams(event.userId));

    final activeRentRes =
        await _getApprovedOrTrackedRent(GetLatestRentParams(event.userId));

    currentMonthRes.fold(
      (failure) => emit(RentFailure(failure.message)),
      (rents) {
        activeRentRes.fold(
          (failure) => emit(RentFailure(failure.message)),
          (activeRent) {
            emit(RentGetAllStatsRentSuccess(
              rents: rents,
              latestRent: activeRent,
            ));
          },
        );
      },
    );
  }
}
