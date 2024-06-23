import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rent_n_trace/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    final user = await remoteDataSource.getCurrentUserData();
    if (user == null) {
      return left(Failure('User belum login'));
    }

    return right(user);
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> loginWithGoogle() async {
    try {
      await remoteDataSource.loginWithGoogle();

      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String email,
    required String fullName,
    required String password,
  }) async {
    return _getUser(
      () async => remoteDataSource.signUpWithEmailPassword(
        email: email,
        fullName: fullName,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
