import 'package:flutter/material.dart';

class RentStatus {
  static const String pending = 'pending';
  static const String rejected = 'rejected';
  static const String approved = 'approved';
  static const String tracked = 'tracked';
  static const String completed = 'completed';

  static const Map<String, String> descriptions = {
    pending: 'Menunggu',
    rejected: 'Ditolak',
    approved: 'Disetujui',
    tracked: 'Dilacak',
    completed: 'Selesai',
  };

  static String getDescription(String? status) {
    return descriptions[status] ?? 'Unknown';
  }

  static Color getBackgroundColor(String status) {
    switch (status) {
      case pending:
        return const Color.fromRGBO(254, 249, 195, 1);
      case rejected:
        return const Color.fromRGBO(254, 226, 226, 1);
      case approved:
        return const Color.fromRGBO(220, 252, 231, 1);
      case tracked:
        return const Color.fromRGBO(219, 234, 254, 1);
      case completed:
        return const Color.fromRGBO(243, 244, 246, 1);
      default:
        return const Color.fromRGBO(243, 244, 246, 1);
    }
  }

  static Color getBorderColor(String status) {
    switch (status) {
      case pending:
        return const Color.fromRGBO(255, 204, 0, 1);
      case rejected:
        return const Color.fromRGBO(255, 153, 153, 1);
      case approved:
        return const Color.fromRGBO(0, 200, 83, 1);
      case tracked:
        return const Color.fromRGBO(64, 156, 255, 1);
      case completed:
        return const Color.fromRGBO(128, 128, 128, 1);
      default:
        return const Color.fromRGBO(128, 128, 128, 1);
    }
  }

  static Color getTextColor(String status) {
    switch (status) {
      case pending:
        return const Color.fromRGBO(133, 77, 14, 1);
      case rejected:
        return const Color.fromRGBO(153, 27, 27, 1);
      case approved:
        return const Color.fromRGBO(22, 101, 52, 1);
      case tracked:
        return const Color.fromRGBO(30, 64, 175, 1);
      case completed:
        return const Color.fromRGBO(31, 41, 55, 1);
      default:
        return const Color.fromRGBO(31, 41, 55, 1);
    }
  }
}
