import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/auth/domain/entity/user.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/get_current_user.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void init() async {
    await Future.delayed(const Duration(seconds: 1));

    var isLoggedIn = await sl<GetCurrentUser>().call();

    isLoggedIn.fold(
      (error) {
        emit(UserUnauthenticated());
      },
      (user) {
        user != null ? emit(UserAuthenticated(user)) : emit(UserUnauthenticated());
      },
    );
  }

  void updateAuthenticated(User user) {
    emit(UserAuthenticated(user));
  }

  void logout() {
    emit(UserUnauthenticated());
  }
}
