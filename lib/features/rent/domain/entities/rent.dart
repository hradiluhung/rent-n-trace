class Rent {
  final String id;
  final String userId;
  final String carId;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final String need;
  final String needDetail;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? driverId;
  final String? userFullName;
  final String? carName;
  final String? carImage;
  final String? carFuelConsumption;
  final String? carFuelType;
  final String? driverName;
  final String? driverPhoto;
  final String? rejectMessage;

  Rent(
      {required this.id,
      required this.userId,
      required this.carId,
      required this.startDate,
      required this.endDate,
      required this.destination,
      required this.need,
      required this.needDetail,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.driverId,
      this.userFullName,
      this.carFuelConsumption,
      this.carFuelType,
      this.carName,
      this.carImage,
      this.driverName,
      this.driverPhoto,
      this.rejectMessage});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'carId': carId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'destination': destination,
      'need': need,
      'needDetail': needDetail,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'driverId': driverId,
      'userFullName': userFullName,
      'carName': carName,
      'carImage': carImage,
      'carFuelConsumption': carFuelConsumption,
      'carFuelType': carFuelType,
      'driverName': driverName,
      'driverPhoto': driverPhoto,
      'rejectMessage': rejectMessage,
    };
  }

  Rent copyWith(
      {String? id,
      String? userId,
      String? carId,
      DateTime? startDate,
      DateTime? endDate,
      String? destination,
      String? need,
      String? needDetail,
      String? status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? driverId,
      String? userFullName,
      String? carName,
      String? carImage,
      String? carFuelConsumption,
      String? carFuelType,
      String? driverName,
      String? driverPhoto,
      String? rejectMessage}) {
    return Rent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destination: destination ?? this.destination,
      need: need ?? this.need,
      needDetail: needDetail ?? this.needDetail,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      driverId: driverId ?? this.driverId,
      userFullName: userFullName ?? this.userFullName,
      carName: carName ?? this.carName,
      carImage: carImage ?? this.carImage,
      carFuelConsumption: carFuelConsumption ?? this.carFuelConsumption,
      carFuelType: carFuelType ?? this.carFuelType,
      driverName: driverName ?? this.driverName,
      driverPhoto: driverPhoto ?? this.driverPhoto,
      rejectMessage: rejectMessage ?? this.rejectMessage,
    );
  }
}
