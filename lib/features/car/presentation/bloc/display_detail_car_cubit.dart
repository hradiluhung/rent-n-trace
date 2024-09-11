import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/domain/usecases/get_car_by_id.dart';
import 'package:rent_n_trace/features/car/presentation/bloc/display_detail_car_state.dart';

class DisplayDetailCarCubit extends Cubit<DisplayDetailCarState> {
  DisplayDetailCarCubit() : super(DisplayDetailCarStateLoading());

  void displayDetailCar(String id) async {
    final result = await sl<GetCarById>().call(params: id);

    result.fold(
      (failure) => emit(DisplayDetailCarStateFailed(failure.message)),
      (car) => emit(DisplayDetailCarStateLoaded(car)),
    );
  }
}
