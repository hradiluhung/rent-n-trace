import 'package:rent_n_trace/features/tracking/domain/entities/real_time_location.dart';

class RealTimeLocationModel extends RealTimeLocation {
  RealTimeLocationModel({
    required super.id,
    required super.isTracking,
    required super.rentId,
    super.latitude,
    super.longitude,
    super.createdAt,
    super.updatedAt,
  });

  factory RealTimeLocationModel.fromJson(Map<String, dynamic> map) {
    return RealTimeLocationModel(
      id: map['id'] as String,
      isTracking: map['is_tracking'] as bool,
      rentId: map['rent_id'] as String,
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'is_tracking': isTracking,
      'rent_id': rentId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
    return data;
  }

  RealTimeLocation copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
    bool? isTracking,
    String? rentId,
  }) {
    return RealTimeLocation(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isTracking: isTracking ?? this.isTracking,
      rentId: rentId ?? this.rentId,
    );
  }
}
