import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/rent_history/get_all_rent_histories.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_all_rent_histories_state.dart';

class DisplayAllRentHistoriesCubit extends Cubit<DisplayAllRentHistoriesState> {
  DisplayAllRentHistoriesCubit() : super(DisplayRentHistoriesLoading());

  void displayRentHistories() async {
    final returnedData = await sl<GetAllRentHistories>().call();

    returnedData.fold(
      (failure) => emit(DisplayRentHistoriesFailed(failure.message)),
      (rentHistories) => emit(DisplayRentHistoriesLoaded(rentHistories)),
    );
  }
}
