import 'package:rent_n_trace/features/booking/domain/entities/driver.dart';

class DriverModel extends Driver {
  DriverModel({
    required super.id,
    required super.name,
    required super.isAvailable,
  });

  factory DriverModel.fromJson(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  DriverModel copyWith({
    String? id,
    String? name,
    bool? isAvailable,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
