import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';

class RentHistoryModel extends RentHistory {
  RentHistoryModel({
    required super.id,
    required super.rentId,
    required super.latlongs,
    required super.distance,
    required super.fuelCost,
    super.carImage,
    super.carName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rentId': rentId,
      'latlongs': latlongs,
      'distance': distance,
      'fuelCost': fuelCost,
      'carImage': carImage,
      'carName': carName,
    };
  }

  factory RentHistoryModel.fromMap(Map<String, dynamic> map) {
    return RentHistoryModel(
      id: map['id'] as String,
      rentId: map['rent_id'] as String,
      latlongs: List<String>.from(map['latlongs'] as List),
      distance: map['distance'] as double,
      fuelCost: map['fuel_cost'] as double,
      carImage: map['rents']?['cars']?['image'] as String?,
      carName: map['rents']?['cars']?['name'] as String?,
    );
  }

  RentHistoryModel copyWith({
    String? id,
    String? rentId,
    List<String>? latlongs,
    double? distance,
    double? fuelCost,
    String? carImage,
    String? carName,
  }) {
    return RentHistoryModel(
      id: id ?? this.id,
      rentId: rentId ?? this.rentId,
      latlongs: latlongs ?? this.latlongs,
      distance: distance ?? this.distance,
      fuelCost: fuelCost ?? this.fuelCost,
      carImage: carImage ?? this.carImage,
      carName: carName ?? this.carName,
    );
  }
}
