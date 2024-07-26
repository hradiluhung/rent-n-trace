import 'dart:io';
import 'package:path/path.dart';
import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Session? get currentUserSession;

  Future<String> uploadProfileImage({
    required File photo,
    required UserModel user,
  });

  Future<UserModel> updateUserProfile({
    required UserModel user,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> updateUserProfile({required UserModel user}) async {
    try {
      final profileData = await supabaseClient
          .from("profiles")
          .update(
            {
              "full_name": user.fullName,
              "division": user.division,
              "photo": user.photo,
            },
          )
          .eq("id", user.id)
          .select();

      final userModel = UserModel.fromJson(profileData.first).copyWith(
        email: currentUserSession!.user.email,
      );

      return userModel;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage(
      {required File photo, required UserModel user}) async {
    try {
      if (user.photo != null) {
        final data = await supabaseClient.storage
            .from("profile_pictures")
            .list(path: user.id);
        final filesToRemove = data.map((x) => "${user.id}/${x.name}").toList();
        await supabaseClient.storage.from("profile_pictures").remove(
              filesToRemove,
            );
      }

      await supabaseClient.storage.from("profile_pictures").upload(
            "${user.id}/${basename(photo.path)}",
            photo,
          );

      return supabaseClient.storage
          .from("profile_pictures")
          .getPublicUrl("${user.id}/${basename(photo.path)}");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
