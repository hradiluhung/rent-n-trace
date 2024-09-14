import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/rent_history/get_detail_rent_history.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_history_state.dart';

class DisplayDetailRentHistoryCubit extends Cubit<DisplayDetailRentHistoryState> {
  DisplayDetailRentHistoryCubit() : super(DisplayDetailRentHistoryLoading());

  void displayDetailRentHistory(String id) async {
    emit(DisplayDetailRentHistoryLoading());
    final result = await sl<GetDetailRentHistory>().call(params: id);
    
    result.fold(
      (failure) => emit(DisplayDetailRentHistoryFailed(failure.message)),
      (rentHistory) => emit(DisplayDetailRentHistoryLoaded(rentHistory)),
    );
  }
}
