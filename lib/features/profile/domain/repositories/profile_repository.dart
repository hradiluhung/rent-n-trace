import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/update_user_req.dart';

abstract class ProfileRepository {
  Future<Either> updateProfile(UpdateUserReq updateUserReq);
}
