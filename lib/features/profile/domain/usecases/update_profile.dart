import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/update_user_req.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile extends UseCase<Either, UpdateUserReq>{
  @override
  Future<Either> call({UpdateUserReq? params}) async{
    return await sl<ProfileRepository>().updateProfile(params!);
  }
}