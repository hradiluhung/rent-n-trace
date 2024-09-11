import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/driver/domain/usecases/get_available_drivers.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_available_drivers_state.dart';

class DisplayAvailableDriversCubit extends Cubit<DisplayAvailableDriversState> {
  DisplayAvailableDriversCubit() : super(DisplayDriversLoading());

  void displayDrivers(DateRangeReq dateRangeReq) async {
    final returnedData = await sl<GetAvailableDrivers>().call(params: dateRangeReq);

    returnedData.fold(
      (error) => emit(DisplayDriversFailed(error.message)),
      (data) => emit(DisplayDriversLoaded(data)),
    );
  }
}
