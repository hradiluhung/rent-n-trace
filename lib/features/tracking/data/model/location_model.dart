import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';

class LocationModel extends Location {
  LocationModel({
    required super.id,
    required super.rentId,
    required super.lat,
    required super.long,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rentId': rentId,
      'lat': lat,
      'long': long,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as String,
      rentId: map['rentId'] as String,
      lat: map['lat'] as double,
      long: map['long'] as double,
    );
  }

  LocationModel copyWith({
    String? id,
    String? rentId,
    double? lat,
    double? long,
  }) {
    return LocationModel(
      id: id ?? this.id,
      rentId: rentId ?? this.rentId,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      id: location.id,
      rentId: location.rentId,
      lat: location.lat,
      long: location.long,
    );
  }
}
