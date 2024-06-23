import 'package:rent_n_trace/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? username,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
    );
  }
}
