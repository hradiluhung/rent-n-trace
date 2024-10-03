import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/update_user_req.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDatasource {
  Future<Either> updateProfile(UpdateUserReq updateUserReq);
}

class ProfileRemoteDatasourceImpl extends ProfileRemoteDatasource {
  @override
  Future<Either> updateProfile(UpdateUserReq updateUserReq) async {
    try {
      String? newPhotoUrl;

      final newPhoto = updateUserReq.newPhoto;
      if (newPhoto != null) {
        final fileExtension = newPhoto.path.split('.').last;
        String photoDirectory = "${updateUserReq.id}$fileExtension";

        final fullPath = await sl<SupabaseClient>()
            .storage
            .from('profile_photos')
            .upload(photoDirectory, newPhoto, fileOptions: const FileOptions(upsert: true));

        newPhotoUrl = sl<SupabaseClient>().storage.from('profile_photos').getPublicUrl(fullPath);

        print("newPhotoUrl: $newPhotoUrl");
      }

      final updateData = {
        'full_name': updateUserReq.fullName,
        'username': updateUserReq.username,
        'division_id': updateUserReq.divisionId,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      if (newPhotoUrl != null) {
        updateData['photo'] = newPhotoUrl;
      }

      final users = await sl<SupabaseClient>()
          .from('profiles')
          .update(updateData)
          .eq('id', updateUserReq.id!)
          .select('*, divisions(id, name)');

      return Right(UserModel.fromMap(users.first));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure("Silakan coba lagi!"));
    }
  }
}
