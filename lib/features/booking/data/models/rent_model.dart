import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';

class RentModel extends Rent {
  RentModel({
    super.updatedAt,
    required super.startDateTime,
    required super.endDateTime,
    required super.destination,
    required super.userId,
    required super.id,
    super.carId,
    super.fuelConsumption,
    super.createdAt,
    super.carName,
    required super.need,
    required super.needDetail,
    super.driverId,
    super.driverName,
    super.carImage,
    super.status,
  });

  factory RentModel.fromJson(Map<String, dynamic> map) {
    return RentModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      carId: map['car_id'] as String,
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      startDateTime: DateTime.parse(map['start_datetime'] ?? ''),
      endDateTime: map['end_datetime'] == null
          ? DateTime.now()
          : DateTime.parse(map['end_datetime']),
      destination: map['destination'] as String,
      fuelConsumption: map['fuel_consumption'],
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at']),
      carName: map['car_name'] ?? '',
      driverId: map['driver_id'] ?? '',
      driverName: map['driver_name'] ?? '',
      need: map['need'] as String,
      needDetail: map['need_detail'] as String,
      carImage: map['car_image'] ?? '',
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'user_id': userId,
      'car_id': carId,
      'start_datetime': startDateTime.toIso8601String(),
      'end_datetime': endDateTime.toIso8601String(),
      'destination': destination,
      'fuel_consumption': fuelConsumption,
      'need': need,
      'need_detail': needDetail,
      'driver_id': driverId,
    };

    // Add created_at only if it's not null
    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }

    // Add updated_at only if it's not null
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toIso8601String();
    }

    return data;
  }

  RentModel copyWith({
    String? id,
    String? userId,
    String? carId,
    DateTime? updatedAt,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? destination,
    int? fuelConsumption,
    DateTime? createdAt,
    String? carName,
    String? driverId,
    String? driverName,
    String? need,
    String? needDetail,
    String? carImage,
    String? status,
  }) {
    return RentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      updatedAt: updatedAt ?? this.updatedAt,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      destination: destination ?? this.destination,
      fuelConsumption: fuelConsumption ?? this.fuelConsumption,
      createdAt: createdAt ?? this.createdAt,
      carName: carName ?? this.carName,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      need: need ?? this.need,
      needDetail: needDetail ?? this.needDetail,
      carImage: carImage ?? this.carImage,
      status: status ?? this.status,
    );
  }
}
