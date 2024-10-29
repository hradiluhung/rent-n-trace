class User {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? divisionId;
  final String? divisionName;
  final String? photo;
  final bool isVerified;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.divisionId,
    this.divisionName,
    this.photo,
    required this.isVerified,
  });
}
