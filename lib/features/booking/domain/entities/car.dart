class Car {
  final String id;
  final String name;
  final int fuelConsumption;
  final String fuelType;
  final String status;
  final List<String?> images;

  const Car({
    required this.id,
    required this.name,
    required this.fuelConsumption,
    required this.fuelType,
    required this.status,
    this.images = const [],
  });
}
