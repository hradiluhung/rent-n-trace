import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(NavbarState(currentIndex: 0));

  void changeIndex(int index) {
    emit(NavbarState(currentIndex: index));
  }
}
