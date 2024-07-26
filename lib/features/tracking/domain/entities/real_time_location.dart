class RealTimeLocation {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? latitude;
  final double? longitude;
  final bool isTracking;
  final String rentId;

  RealTimeLocation({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    required this.isTracking,
    required this.rentId,
  });
}
