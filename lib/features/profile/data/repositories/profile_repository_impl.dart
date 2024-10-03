import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/update_user_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:rent_n_trace/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  @override
  Future<Either> updateProfile(UpdateUserReq updateUserReq) {
    return sl<ProfileRemoteDatasource>().updateProfile(updateUserReq);
  }
}
