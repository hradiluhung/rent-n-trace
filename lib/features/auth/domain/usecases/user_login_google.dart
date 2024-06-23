import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/auth/domain/repository/auth_repository.dart';

class UserLoginGoogle implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  UserLoginGoogle(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return authRepository.loginWithGoogle();
  }
}
