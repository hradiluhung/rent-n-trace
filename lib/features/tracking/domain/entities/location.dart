class Location {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? latitude;
  final double? longitude;
  final bool isRealTime;
  final String rentId;

  Location({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    required this.isRealTime,
    required this.rentId,
  });
}
