import 'package:latlong2/latlong.dart';

class TrackingHistory {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<LatLng>? positions;
  final String? rentId;
  final double? distance;

  const TrackingHistory({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.positions,
    required this.rentId,
    required this.distance,
  });
}
