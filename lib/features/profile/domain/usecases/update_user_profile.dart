import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/profile/domain/repositories/profile_repository.dart';

class UpdateUserProfile implements UseCase<User, UpdateUserProfileParams> {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(
        user: params.userProfile, photo: params.photo);
  }
}

class UpdateUserProfileParams {
  final User userProfile;
  final File? photo;

  UpdateUserProfileParams(this.userProfile, this.photo);
}
