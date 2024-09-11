import 'package:flutter/material.dart';

class CarStatus {
  static const String available = 'available';
  static const String booked = 'booked';
  static const String maintenance = 'maintenance';

  static const Map<String, String> descriptions = {
    available: 'Tersedia',
    booked: 'Dibooking',
    maintenance: 'Sedang Maintenance',
  };

  static String getDescription(String status) {
    return descriptions[status] ?? 'Unknown';
  }

  static Color getBackgroundColor(String status) {
    switch (status) {
      case available:
        return const Color.fromRGBO(220, 252, 231, 1);
      case booked:
        return const Color.fromRGBO(254, 249, 195, 1);
      case maintenance:
        return const Color.fromRGBO(243, 244, 246, 1);
      default:
        return const Color.fromRGBO(243, 244, 246, 1);
    }
  }

  static Color getTextColor(String status) {
    switch (status) {
      case available:
        return const Color.fromRGBO(22, 101, 52, 1);
      case booked:
        return const Color.fromRGBO(133, 77, 14, 1);
      case maintenance:
        return const Color.fromRGBO(31, 41, 55, 1);
      default:
        return const Color.fromRGBO(31, 41, 55, 1);
    }
  }
}
