class RentHistory {
  final String id;
  final String rentId;
  final List<String> latlongs;
  final double distance;
  final double fuelCost;
  final String? carImage;
  final String? carName;

  RentHistory({
    required this.id,
    required this.rentId,
    required this.latlongs,
    required this.distance,
    required this.fuelCost,
    this.carImage,
    this.carName,
  });

  // TODO: Remove this later
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rentId': rentId,
      'latlongs': latlongs,
      'distance': distance,
      'fuelCost': fuelCost,
      'carImage': carImage,
      'carName': carName,
    };
  }
}
