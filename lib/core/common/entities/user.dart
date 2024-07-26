class User {
  final String id;
  final String email;
  final String fullName;
  final String? division;
  final String? photo;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.division,
    this.photo,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'division': division,
      'photo': photo,
    };
  }
}
