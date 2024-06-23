import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/current_user.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/user_login.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/user_login_google.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/user_logout.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final CurrentUser _currentUser;
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final UserLogout _userLogout;
  final UserLoginGoogle _userLoginGoogle;

  AuthBloc({
    required UserSignUp userSignUp,
    required AppUserCubit appUserCubit,
    required CurrentUser currentUser,
    required UserLogin userLogin,
    required UserLogout userLogout,
    required UserLoginGoogle userLoginGoogle,
  })  : _userSignUp = userSignUp,
        _appUserCubit = appUserCubit,
        _currentUser = currentUser,
        _userLogin = userLogin,
        _userLogout = userLogout,
        _userLoginGoogle = userLoginGoogle,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLoginGoogle>(_onAuthLoginGoogle);
    on<AuthLogout>(_onAuthLogout);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(
      UserSignUpParams(
          email: event.email,
          fullName: event.fullName,
          password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccessAuth(user));
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    final res = await _userLogout(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        _appUserCubit.updateUser(null);
        emit(AuthSuccessLogout());
      },
    );
  }

  void _onAuthLoginGoogle(
      AuthLoginGoogle event, Emitter<AuthState> emit) async {
    final res = await _userLoginGoogle(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthSuccessLoginWithGoogle()),
    );
  }
}
