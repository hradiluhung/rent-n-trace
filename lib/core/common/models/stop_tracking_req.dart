class StopTrackingReq {
  String? locationId;
  String? rentId;
  List<String>? latlongs;
  double? distance;
  double? fuelCost;

  StopTrackingReq({
    this.locationId,
    this.rentId,
    this.latlongs,
    this.distance,
    this.fuelCost,
  });

  // To json

  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'rentId': rentId,
      'latlongs': latlongs,
      'distance': distance,
      'fuelCost': fuelCost,
    };
  }
}
