import 'package:rent_n_trace/features/profile/domain/entity/division.dart';

class DivisionModel extends Division {
  DivisionModel({
    required super.id,
    required super.name,
  });

  factory DivisionModel.fromMap(Map<String, dynamic> map) {
    return DivisionModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
