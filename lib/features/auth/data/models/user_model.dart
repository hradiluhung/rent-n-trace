import 'package:rent_n_trace/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.division,
    super.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? '',
      division: map['division'],
      photo: map['photo'],
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? division,
    String? photo,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      division: division ?? this.division,
      photo: photo ?? this.photo,
    );
  }
}
