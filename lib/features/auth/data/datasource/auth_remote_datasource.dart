import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/user_creation_req.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDatasource {
  Future<Either> signup(UserCreationReq user);
  Future<Either> signin({
    required String emailOrUsername,
    required String password,
  });
  Future<Either> getCurrentUser();
  Future<Either> logout();
}

class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  @override
  Future<Either> getCurrentUser() async {
    try {
      final currentSession = sl<SupabaseClient>().auth.currentSession;

      if (currentSession != null) {
        final userData = await getUserById(currentSession.user.id);
        return Right(userData);
      }

      return Left(Failure('User belum login'));
    } on AuthException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> signin({required String emailOrUsername, required String password}) async {
    try {
      final isEmail = emailOrUsername.contains('@');

      if (isEmail) {
        final authData = await sl<SupabaseClient>().auth.signInWithPassword(
              email: emailOrUsername,
              password: password,
            );

        if (authData.user == null) {
          return Left(Failure('Email atau password salah'));
        }

        final userData = await getUserById(authData.user!.id);
        return Right(userData);
      } else {
        final userData = await sl<SupabaseClient>()
            .from('profiles')
            .select('*, divisions(name)')
            .eq('username', emailOrUsername)
            .limit(1);

        if (userData.isEmpty) {
          return Left(Failure('Username tidak ditemukan'));
        }

        final email = userData.first['email'] as String;
        final authData = await sl<SupabaseClient>().auth.signInWithPassword(
              email: email,
              password: password,
            );

        if (authData.user == null) {
          return Left(Failure('Email atau password salah'));
        }

        return Right(UserModel.fromMap(userData.first));
      }
    } on AuthException catch (e) {
      String message = '';

      if (e.code == 'invalid_credentials') {
        message = 'Email atau password salah';
      } else if (e.message == "Invalid login credentials") {
        message = 'Email atau password salah';
      } else {
        message = e.message;
      }

      return Left(Failure(message));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> logout() async {
    try {
      await sl<SupabaseClient>().auth.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(Failure(e.message));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> signup(UserCreationReq user) async {
    try {
      final usernameData = await sl<SupabaseClient>()
          .from('profiles')
          .select('id')
          .eq('username', user.username!)
          .limit(1);

      if (usernameData.isNotEmpty) {
        return Left(Failure('Username sudah terdaftar'));
      }

      final response = await sl<SupabaseClient>().auth.signUp(
        email: user.email,
        password: user.password!,
        data: {
          'full_name': user.fullName,
          'username': user.username,
        },
      );

      final userData = await getUserById(response.user!.id);
      return Right(userData);
    } on AuthException catch (e) {
      String message = '';
      print(e);
      if (e.code == 'user_already_exists') {
        message = 'Email sudah terdaftar';
      }

      return Left(Failure(message));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUserById(String id) async {
    final userData = await sl<SupabaseClient>()
        .from('profiles')
        .select('*, divisions(name)')
        .eq('id', id)
        .limit(1);

    return UserModel.fromMap(userData.first);
  }
}
