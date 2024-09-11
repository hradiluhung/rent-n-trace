import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/domain/usecases/get_all_cars.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/display_cars_state.dart';

class DisplayCarsCubit extends Cubit<DisplayCarsState> {
  DisplayCarsCubit() : super(DisplayCarsLoading());

  void displayCars() async {
    final loadedCars = await sl<GetAllCars>().call();

    loadedCars.fold(
      (error) => emit(DisplayCarsFailed(message: error.message)),
      (data) => emit(DisplayCarsLoaded(cars: data)),
    );
  }
}
