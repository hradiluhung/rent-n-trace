import 'package:rent_n_trace/features/auth/domain/entity/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullName,
    required super.username,
    required super.email,
    super.divisionId,
    super.divisionName,
    super.photo,
    required super.isVerified,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'divisonId': divisionId,
      'divisionName': divisionName,
      'photo': photo,
      'isVerified': isVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      divisionId: map['division_id'] as String?,
      divisionName: map['divisions']?['name'] as String?,
      photo: map['photo'] != null ? map['photo'] as String : null,
      isVerified: map['is_verified'] as bool,
    );
  }

  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? divisionId,
    String? divisionName,
    String? photo,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      divisionId: divisionId ?? this.divisionId,
      divisionName: divisionName ?? this.divisionName,
      photo: photo ?? this.photo,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
