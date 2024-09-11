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

  Rent({
    required this.id,
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
  });
}
