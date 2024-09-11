import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toMMMMyyyy() {
    DateFormat formatter = DateFormat('MMMM yyyy', 'id_ID');

    return formatter.format(this);
  }

  String toddMMMMyyyy() {
    DateFormat formatter = DateFormat('dd MMMM yyyy', 'id_ID');

    return formatter.format(this);
  }

  String toHHmmddMMMMyyyy() {
    DateFormat formatter = DateFormat('HH:mm - dd MMMM yyyy', 'id_ID');

    return formatter.format(this);
  }

  String toddMMMMyyyyShort() {
    DateFormat formatter = DateFormat('dd MMM yyyy', 'id_ID');

    return formatter.format(this);
  }
}
