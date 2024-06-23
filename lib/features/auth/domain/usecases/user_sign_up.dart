import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      email: params.email,
      fullName: params.fullName,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String fullName;
  final String password;

  UserSignUpParams({
    required this.email,
    required this.fullName,
    required this.password,
  });
}
