import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/display_rent_stats_state.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/get_curr_month_rents.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/get_latest_rent.dart';

class DislayRentStatsCubit extends Cubit<DislayRentStatsState> {
  DislayRentStatsCubit() : super(DislayRentStatsLoading());

  void displayCurrentRents() async {
    final currentMonthRents = await sl<GetCurrMonthRents>().call();
    final latestRent = await sl<GetLatestRent>().call();

    try {
      currentMonthRents.fold(
        (error) => emit(DislayRentStatsFailed(message: error.message)),
        (currentMonthRents) {
          latestRent.fold(
            (error) => emit(DislayRentStatsFailed(message: error.message)),
            (latestRent) => emit(
              DislayRentStatsLoaded(currentMonthRents: currentMonthRents, latestRent: latestRent),
            ),
          );
        },
      );
    } catch (e) {
      emit(DislayRentStatsFailed(message: e.toString()));
    }
  }
}
