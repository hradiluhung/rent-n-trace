import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';

class RentModel extends Rent {
  RentModel({
    required super.id,
    required super.userId,
    required super.carId,
    required super.startDate,
    required super.endDate,
    required super.destination,
    required super.need,
    required super.needDetail,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.driverId,
    super.userFullName,
    super.carName,
    super.carImage,
    super.driverName,
    super.carFuelConsumption,
    super.carFuelType,
    super.driverPhoto
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'carId': carId,
      'driverId': driverId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'destination': destination,
      'need': need,
      'needDetail': needDetail,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'userFullName': userFullName,
      'carName': carName,
      'driverName': driverName,
      'carImage': carImage,
      'carFuelConsumption': carFuelConsumption,
      'carFuelType': carFuelType,
      'driverPhoto': driverPhoto,
    };
  }

  factory RentModel.fromMap(Map<String, dynamic> map) {
    return RentModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      carId: map['car_id'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      destination: map['destination'] as String,
      need: map['need'] as String,
      needDetail: map['need_detail'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      driverId: map['driver_id'] != null ? map['driver_id'] as String : null,
      userFullName: map['profiles']?['full_name'] as String?,
      carName: map['cars']?['name'] as String?,
      carImage: map['cars']?['image'] as String?,
      driverName: map['drivers']?['name'] as String?,
      carFuelConsumption: map['cars']?['fuel_consumption'] as String?,
      carFuelType: map['cars']?['fuel_type'] as String?,
      driverPhoto: map['drivers']?['photo'] as String?,
    );
  }

  RentModel copyWith({
    String? id,
    String? userId,
    String? carId,
    String? driverId,
    DateTime? startDate,
    DateTime? endDate,
    String? destination,
    String? need,
    String? needDetail,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userFullName,
    String? carName,
    String? driverName,
    String? carImage,
    String? carFuelConsumption,
    String? carFuelType,
    String? driverPhoto,
  }) {
    return RentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      driverId: driverId ?? this.driverId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destination: destination ?? this.destination,
      need: need ?? this.need,
      needDetail: needDetail ?? this.needDetail,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userFullName: userFullName ?? this.userFullName,
      carName: carName ?? this.carName,
      driverName: driverName ?? this.driverName,
      carImage: carImage ?? this.carImage,
      carFuelConsumption: carFuelConsumption ?? this.carFuelConsumption,
      carFuelType: carFuelType ?? this.carFuelType,
      driverPhoto: driverPhoto ?? this.driverPhoto,
    );
  }
}
