class Car {
  final String id;
  final String name;
  final String fuelConsumption;
  final String fuelType;
  final String status;
  final List<String?> images;

  Car({
    required this.id,
    required this.name,
    required this.fuelConsumption,
    required this.fuelType,
    required this.status,
    this.images = const [],
  });
}
