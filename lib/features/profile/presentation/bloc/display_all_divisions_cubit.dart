import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/profile/domain/usecases/get_all_divisions.dart';
import 'package:rent_n_trace/features/profile/presentation/bloc/display_all_divisions_state.dart';

class DisplayAllDivisionsCubit extends Cubit<DisplayAllDivisionsState> {
  DisplayAllDivisionsCubit() : super(DisplayAllDivisionsLoading());

  void displayDivisions() async {
    final returnData = await sl<GetAllDivisions>().call();

    returnData.fold(
      (failure) => emit(DisplayAllDivisionsFailed(failure.message)),
      (divisions) => emit(DisplayAllDivisionsLoaded(divisions)),
    );
  }
}
