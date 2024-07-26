import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/features/profile/domain/usecases/update_user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppUserCubit _appUserCubit;
  final UpdateUserProfile _updateUserProfile;

  ProfileBloc({
    required AppUserCubit appUserCubit,
    required UpdateUserProfile updateUserProfile,
  })  : _appUserCubit = appUserCubit,
        _updateUserProfile = updateUserProfile,
        super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) => emit(ProfileLoading()));
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onUpdateUserProfile(
      UpdateUserProfileEvent event, Emitter<ProfileState> emit) async {
    final res = await _updateUserProfile(
        UpdateUserProfileParams(event.user, event.photo));

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (user) {
        _appUserCubit.updateUser(user);
        emit(ProfileUpdateSuccess(user));
      },
    );
  }
}
