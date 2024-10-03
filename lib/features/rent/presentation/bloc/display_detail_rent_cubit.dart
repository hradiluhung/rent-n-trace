import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/rent/get_detail_rent.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_state.dart';

class DisplayDetailRentCubit extends Cubit<DisplayDetailRentState> {
  DisplayDetailRentCubit() : super(DisplayDetailRentLoading());

  void displayDetailRent(String id) async {
    final returnedData = await sl<GetDetailRent>().call(params: id);

    returnedData.fold(
      (error) => emit(DisplayDetailRentFailed(error.message)),
      (rent) => emit(DisplayDetailRentLoaded(rent)),
    );
  }

  void updateRentStatus(String newStatus) {
    if (state is DisplayDetailRentLoaded) {
      final currentRent = (state as DisplayDetailRentLoaded).rent;
      final updatedRent = currentRent.copyWith(status: newStatus);
      emit(DisplayDetailRentLoaded(updatedRent));
    }
  }
}
