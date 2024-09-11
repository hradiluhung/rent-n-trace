import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/get_rent_by_id.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_state.dart';

class DisplayDetailRentCubit extends Cubit<DisplayDetailRentState> {
  DisplayDetailRentCubit() : super(DisplayDetailRentLoading());

  void displayDetailRent(String id) async {
    final returnedData = await sl<GetRentById>().call(params: id);

    returnedData.fold(
      (error) => emit(DisplayDetailRentFailed(error.message)),
      (rent) => emit(DisplayDetailRentLoaded(rent)),
    );
  }
}
