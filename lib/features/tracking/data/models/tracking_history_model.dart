import 'package:latlong2/latlong.dart';
import 'package:rent_n_trace/features/tracking/domain/entities/tracking_history.dart';

class TrackingHistoryModel extends TrackingHistory {
  TrackingHistoryModel({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required super.positions,
    required super.rentId,
    required super.distance,
  });

  factory TrackingHistoryModel.fromJson(Map<String, dynamic> map) {
    return TrackingHistoryModel(
      id: map['id'] as String,
      createdAt: map['created_at'] == null ? DateTime.now() : DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] == null ? DateTime.now() : DateTime.parse(map['updated_at']),
      positions: map['positions'] == null
          ? []
          : (map['positions'] as List)
              .map((e) => LatLng(
                    double.parse(e.split(",")[0].substring(1)),
                    double.parse(e.split(",")[1].substring(0, e.split(",")[1].length - 1)),
                  ))
              .toList(),
      rentId: map['rent_id'] as String,
      distance: 0,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'positions': positions?.map((e) => "${e.latitude}, ${e.longitude}").toList(),
      'rent_id': rentId,
      'distance': distance,
    };

    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }

    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toIso8601String();
    }
    return data;
  }

  TrackingHistory copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<LatLng>? positions,
    String? rentId,
  }) {
    return TrackingHistory(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      positions: positions ?? this.positions,
      rentId: rentId ?? this.rentId,
      distance: distance,
    );
  }
}
