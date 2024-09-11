import 'package:rent_n_trace/features/driver/domain/entity/driver.dart';

class DriverModel extends Driver {
  DriverModel({
    required super.id,
    required super.name,
    required super.status,
    super.photo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'photo': photo,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  DriverModel copyWith({
    String? id,
    String? name,
    String? status,
    String? photo,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      photo: photo ?? this.photo,
    );
  }
}
