import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/get_active_location.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_active_location_state.dart';

class DisplayActiveLocationCubit extends Cubit<DisplayActiveLocationState> {
  DisplayActiveLocationCubit() : super(DisplayLocationLoading());

  void displayLocation(String rentId) async {
    final returnedData = await sl<GetActiveLocation>().call(params: rentId);

    print("ReturnedData: $returnedData");

    returnedData.fold(
      (error) => emit(DisplayLocationFailed(error.message)),
      (data) => emit(DisplayLocationLoaded(data)),
    );
  }
}
