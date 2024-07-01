import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/create_rent.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/get_all_user_rents.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/get_current_month_rents.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/get_latest_rent.dart';
import 'package:rent_n_trace/features/booking/domain/usecases/rents/update_cancel_rent.dart';

part 'rent_event.dart';
part 'rent_state.dart';

class RentBloc extends Bloc<RentEvent, RentState> {
  final GetCurrentMonthRents _getCurrentMonthRent;
  final GetLatestRent _getApprovedOrTrackedRent;
  final CreateRent _createRent;
  final UpdateCancelRent _updateCancelRent;
  final GetAllUserRents _getAllUserRents;

  RentBloc({
    required GetCurrentMonthRents getCurrentMonthRent,
    required GetLatestRent getApprovedOrTrackedRent,
    required CreateRent createRent,
    required UpdateCancelRent updateCancelRent,
    required GetAllUserRents getAllUserRents,
  })  : _getCurrentMonthRent = getCurrentMonthRent,
        _getApprovedOrTrackedRent = getApprovedOrTrackedRent,
        _createRent = createRent,
        _updateCancelRent = updateCancelRent,
        _getAllUserRents = getAllUserRents,
        super(RentInitial()) {
    on<RentEvent>((event, emit) => emit(RentLoading()));
    on<RentGetAllStatsRent>(_onGetCurrentMonthRent);
    on<RentCreateRent>(_onCreateRent);
    on<RentUpdateCancelRent>(_onUpdateCancelRent);
    on<RentGetAllUserRents>(_onGetAllUserRents);
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
            emit(RentAllRentStatsLoaded(
              rents: rents,
              latestRent: activeRent,
            ));
          },
        );
      },
    );
  }

  void _onUpdateCancelRent(
      RentUpdateCancelRent event, Emitter<RentState> emit) async {
    final res = await _updateCancelRent(UpdateCancelRentParams(event.rentId));

    res.fold(
      (failure) => emit(RentFailure(failure.message)),
      (message) => emit(RentUpdateRentSuccess(message)),
    );
  }

  void _onGetAllUserRents(
      RentGetAllUserRents event, Emitter<RentState> emit) async {
    final res = await _getAllUserRents(event.userId);

    res.fold(
      (failure) => emit(RentFailure(failure.message)),
      (rents) => emit(RentMultipleRentsLoaded(rents)),
    );
  }
}
