import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/bottom_bar_state.dart';

class BottomBarCubit extends Cubit<BottomBarState> {
  BottomBarCubit() : super(BottomBarState(currentIndex: 0));

  void changeIndex(int index) {
    emit(BottomBarState(currentIndex: index));
  }
}
