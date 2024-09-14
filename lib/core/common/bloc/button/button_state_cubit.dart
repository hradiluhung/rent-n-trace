import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitial());

  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(ButtonLoading());
    try {
      Either returnedData = await usecase.call(params: params);
      returnedData.fold((error) {
        emit(ButtonFailure(message: error.message));
      }, (data) {
        emit(ButtonSuccess(data: data));
      });
    } catch (e) {
      emit(ButtonFailure(message: e.toString()));
    }
  }
}
