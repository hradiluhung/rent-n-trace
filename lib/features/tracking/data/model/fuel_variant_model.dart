import 'package:rent_n_trace/features/tracking/domain/entity/fuel_variant.dart';

class FuelVariantModel extends FuelVariant {
  FuelVariantModel({required super.id, required super.name, required super.price});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory FuelVariantModel.fromMap(Map<String, dynamic> map) {
    return FuelVariantModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }

  FuelVariantModel copyWith({
    String? id,
    String? name,
    double? price,
  }) {
    return FuelVariantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}
