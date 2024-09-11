import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/get_current_user.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void init() async {
    await Future.delayed(const Duration(seconds: 1));

    var isLoggedIn = await sl<GetCurrentUser>().call();

    isLoggedIn.fold(
      (error) {
        emit(SplashUnauthenticated());
      },
      (user) {
        user != null ? emit(SplashAuthenticated(user)) : emit(SplashUnauthenticated());
      },
    );
  }
}
