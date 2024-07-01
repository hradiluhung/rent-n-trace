import 'package:rent_n_trace/features/tracking/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({
    required super.id,
    required super.isRealTime,
    required super.rentId,
    super.latitude,
    super.longitude,
    super.createdAt,
    super.updatedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as String,
      isRealTime: map['is_real_time'] as bool,
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
      'is_real_time': isRealTime,
      'rent_id': rentId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
    return data;
  }

  Location copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
    bool? isRealTime,
    String? rentId,
  }) {
    return Location(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isRealTime: isRealTime ?? this.isRealTime,
      rentId: rentId ?? this.rentId,
    );
  }
}
