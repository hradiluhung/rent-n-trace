import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedMMMMyyyy() {
    DateFormat formatter = DateFormat('MMMM yyyy', 'id_ID');

    return formatter.format(this);
  }

  String toFormattedddMMMMyyyy() {
    DateFormat formatter = DateFormat('dd MMMM yyyy', 'id_ID');

    return formatter.format(this);
  }

  String toFormattedHHmmddMMMMyyyy() {
    DateFormat formatter = DateFormat('HH:mm - dd MMMM yyyy', 'id_ID');

    return formatter.format(this);
  }
}
