import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/user_creation_req.dart';
import 'package:rent_n_trace/core/common/models/user_signin_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:rent_n_trace/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> getCurrentUser() async {
    return await sl<AuthRemoteDatasource>().getCurrentUser();
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    return await sl<AuthRemoteDatasource>().signin(
      emailOrUsername: user.emailOrUsername,
      password: user.password,
    );
  }

  @override
  Future<Either> logout() async {
    return await sl<AuthRemoteDatasource>().logout();
  }

  @override
  Future<Either> signup(UserCreationReq user) async {
    return await sl<AuthRemoteDatasource>().signup(user);
  }
}
