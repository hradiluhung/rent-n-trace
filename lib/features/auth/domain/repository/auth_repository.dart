import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/user_creation_req.dart';
import 'package:rent_n_trace/core/common/models/user_signin_req.dart';

abstract class AuthRepository {
  Future<Either> signup(UserCreationReq user);

  Future<Either> signin(UserSigninReq user);

  Future<Either> getCurrentUser();

  Future<Either> logout();
}
