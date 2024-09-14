class RentHistory {
  final String id;
  final String rentId;
  final List<String> latlongs;
  final double distance;
  final DateTime createdAt;
  final double fuelCost;
  final String? carImage;
  final String? carName;
  final String? carFuelType;
  final String ?carFuelConsumption;
  final String? rentStatus;
  final DateTime? rentStartDate;
  final DateTime? rentEndDate;
  final String? rentNeed;
  final String? rentNeedDetail;
  final String? rentDestination;
  final String? driverName;
  final String? driverPhoto;

  RentHistory({
    required this.id,
    required this.rentId,
    required this.latlongs,
    required this.distance,
    required this.fuelCost,
    required this.createdAt,
    this.carImage,
    this.carName,
    this.carFuelConsumption,
    this.carFuelType,
    this.rentEndDate,
    this.rentStartDate,
    this.rentStatus,
    this.rentNeed,
    this.rentNeedDetail,
    this.rentDestination,
    this.driverName,
    this.driverPhoto,
  });
}
