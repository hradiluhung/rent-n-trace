import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/get_all_fuel_variants.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_all_fuel_variants_state.dart';

class DisplayAllFuelVariantsCubit extends Cubit<DisplayAllFuelVariantsState> {
  DisplayAllFuelVariantsCubit() : super(DisplayAllFuelVariantsLoading());

  void displayAllFuelVariants() async {
    final returnedData = await sl<GetAllFuelVariants>().call();

    returnedData.fold(
      (error) => emit(DisplayAllFuelVariantsFailed(error.message)),
      (data) => emit(DisplayAllFuelVariantsLoaded(data)),
    );
  }
}
