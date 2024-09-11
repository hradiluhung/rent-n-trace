class Driver {
  final String id;
  final String name;
  final String status;
  final String? photo;

  Driver({
    required this.id,
    required this.name,
    required this.status,
    this.photo,
  });
}
