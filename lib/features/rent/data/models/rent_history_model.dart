import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';

class RentHistoryModel extends RentHistory {
  RentHistoryModel({
    required super.id,
    required super.rentId,
    required super.latlongs,
    required super.distance,
    required super.fuelCost,
    required super.createdAt,
    super.carImage,
    super.carName,
    super.rentEndDate,
    super.rentStartDate,
    super.rentStatus,
    super.rentDestination,
    super.rentNeed,
    super.rentNeedDetail,
    super.driverName,
    super.driverPhoto,
    super.carFuelConsumption,
    super.carFuelType,
  });

  factory RentHistoryModel.fromMap(Map<String, dynamic> map) {
    return RentHistoryModel(
      id: map['id'] as String,
      rentId: map['rent_id'] as String,
      latlongs: List<String>.from(map['latlongs'] as List),
      distance: map['distance'] as double,
      fuelCost: (map['fuel_cost'] is int)
          ? (map['fuel_cost'] as int).toDouble()
          : map['fuel_cost'] as double,
      createdAt: DateTime.parse(map['created_at'] as String),
      carImage: map['rents']?['cars']?['image'] as String?,
      carName: map['rents']?['cars']?['name'] as String?,
      carFuelConsumption: map['rents']?['cars']?['fuel_consumption'] as String?,
      carFuelType: map['rents']?['cars']?['fuel_type'] as String?,
      rentEndDate:
          map['rents']?['end_date'] != null ? DateTime.parse(map['rents']?['end_date']) : null,
      rentStartDate: map['rents']?['start_date'] != null
          ? DateTime.parse(map['rents']?['start_date'] as String)
          : null,
      rentStatus: map['rents']?['status'] as String?,
      rentDestination: map['rents']?['destination'] as String?,
      rentNeed: map['rents']?['need'] as String?,
      rentNeedDetail: map['rents']?['need_detail'] as String?,
      driverName: map['rents']?['drivers']?['name'] as String?,
      driverPhoto: map['rents']?['drivers']?['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rent_id': rentId,
      'latlongs': latlongs,
      'distance': distance,
      'fuel_cost': fuelCost,
      'created_at': createdAt.toIso8601String(),
      'rents': {
        'cars': {
          'image': carImage,
          'name': carName,
          'fuel_consumption': carFuelConsumption,
          'fuel_type': carFuelType,
        },
        'end_date': rentEndDate?.toIso8601String(),
        'start_date': rentStartDate?.toIso8601String(),
        'status': rentStatus,
        'destination': rentDestination,
        'need': rentNeed,
        'need_detail': rentNeedDetail,
        'drivers': {
          'name': driverName,
          'photo': driverPhoto,
        },
      },
    };
  }

  RentHistoryModel copyWith({
    String? id,
    String? rentId,
    List<String>? latlongs,
    double? distance,
    double? fuelCost,
    DateTime? createdAt,
    String? carImage,
    String? carName,
    String? carFuelType,
    String? carFuelConsumption,
    String? rentStatus,
    DateTime? rentStartDate,
    DateTime? rentEndDate,
    String? rentNeed,
    String? rentNeedDetail,
    String? rentDestination,
    String? driverName,
    String? driverPhoto,
  }) {
    return RentHistoryModel(
      id: id ?? this.id,
      rentId: rentId ?? this.rentId,
      latlongs: latlongs ?? this.latlongs,
      distance: distance ?? this.distance,
      createdAt: createdAt ?? this.createdAt,
      fuelCost: fuelCost ?? this.fuelCost,
      carImage: carImage ?? this.carImage,
      carName: carName ?? this.carName,
      carFuelType: carFuelType ?? this.carFuelType,
      carFuelConsumption: carFuelConsumption ?? this.carFuelConsumption,
      rentStatus: rentStatus ?? this.rentStatus,
      rentStartDate: rentStartDate ?? this.rentStartDate,
      rentEndDate: rentEndDate ?? this.rentEndDate,
      rentNeed: rentNeed ?? this.rentNeed,
      rentNeedDetail: rentNeedDetail ?? this.rentNeedDetail,
      rentDestination: rentDestination ?? this.rentDestination,
      driverName: driverName ?? this.driverName,
      driverPhoto: driverPhoto ?? this.driverPhoto,
    );
  }
}
