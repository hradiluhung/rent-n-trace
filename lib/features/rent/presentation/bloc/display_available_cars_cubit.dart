import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/domain/usecases/get_available_car.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_available_cars_state.dart';

class DisplayAvailableCarsCubit extends Cubit<DisplayAvailableCarsState> {
  DisplayAvailableCarsCubit() : super(DisplayCarsLoading());

  void displayCars(DateRangeReq dateRange) async {
    final returnedData = await sl<GetAvailableCars>().call(params: dateRange);

    returnedData.fold(
      (error) => emit(DisplayCarsFailed(error.message)),
      (data) => emit(DisplayCarsLoaded(data)),
    );
  }
}
