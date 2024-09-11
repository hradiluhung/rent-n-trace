import 'package:rent_n_trace/features/car/domain/entity/car.dart';

class CarModel extends Car {
  CarModel({
    required super.id,
    required super.name,
    required super.fuelConsumption,
    required super.fuelType,
    required super.status,
    required super.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'fuelConsumption': fuelConsumption,
      'fuelType': fuelType,
      'status': status,
      'image': image,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] as String,
      name: map['name'] as String,
      fuelConsumption: map['fuel_consumption'] as String,
      fuelType: map['fuel_type'] as String,
      status: map['status'] as String,
      image: map['image'] as String,
    );
  }

  CarModel copyWith({
    String? id,
    String? name,
    String? fuelConsumption,
    String? fuelType,
    String? status,
    String? image,
  }) {
    return CarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fuelConsumption: fuelConsumption ?? this.fuelConsumption,
      fuelType: fuelType ?? this.fuelType,
      status: status ?? this.status,
      image: image ?? this.image,
    );
  }
}
