import 'package:rent_n_trace/features/auth/domain/entity/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullName,
    required super.username,
    required super.email,
    super.divisionName,
    super.photo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'divisionName': divisionName,
      'photo': photo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      divisionName: map['divisions.name'] != null ? map['divisions.name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? divisionName,
    String? photo,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      divisionName: divisionName ?? this.divisionName,
      photo: photo ?? this.photo,
    );
  }
}
