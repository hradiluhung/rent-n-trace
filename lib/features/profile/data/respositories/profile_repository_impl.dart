import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/auth/data/models/user_model.dart';
import 'package:rent_n_trace/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:rent_n_trace/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl(this.profileRemoteDataSource);

  @override
  Future<Either<Failure, User>> updateUserProfile(
      {required User user, File? photo}) async {
    try {
      UserModel userModel = UserModel(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        division: user.division,
        photo: user.photo,
      );

      String? photoUrl;
      if (photo != null) {
        photoUrl = await profileRemoteDataSource.uploadProfileImage(
          photo: photo,
          user: userModel,
        );
      }
      userModel = userModel.copyWith(photo: photoUrl);

      final uploadedUser = await profileRemoteDataSource.updateUserProfile(
        user: userModel,
      );

      return right(uploadedUser);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
