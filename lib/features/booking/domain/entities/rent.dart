class Rent {
  final String? id;
  final String userId;
  final String? carId;
  final DateTime? updatedAt;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String destination;
  final int? fuelConsumption;
  final DateTime? createdAt;
  final String need;
  final String needDetail;
  final String? driverId;
  final String? driverName;
  final String? carName;
  final String? carImage;
  final String? status;

  Rent({
    this.id,
    required this.userId,
    this.carId,
    this.updatedAt,
    required this.startDateTime,
    required this.endDateTime,
    required this.destination,
    this.fuelConsumption,
    this.createdAt,
    required this.need,
    required this.needDetail,
    this.driverId,
    this.driverName,
    this.carName,
    this.carImage,
    this.status,
  });
}
