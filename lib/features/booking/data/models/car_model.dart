import 'package:rent_n_trace/features/booking/domain/entities/car.dart';

class CarModel extends Car {
  CarModel({
    required super.id,
    required super.name,
    required super.fuelConsumption,
    required super.fuelType,
    required super.status,
    super.images,
  });

  factory CarModel.fromJson(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      fuelConsumption: map['fuel_consumption'] ?? 0,
      fuelType: map['fuel_type'] ?? '',
      status: map['status'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  CarModel copyWith({
    String? id,
    String? name,
    int? fuelConsumption,
    String? fuelType,
    String? status,
    List<String>? images,
  }) {
    return CarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fuelConsumption: fuelConsumption ?? this.fuelConsumption,
      fuelType: fuelType ?? this.fuelType,
      status: status ?? this.status,
      images: images ?? this.images,
    );
  }
}
