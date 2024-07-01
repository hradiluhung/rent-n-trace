import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class CarStatus {
  static const String available = 'available';
  static const String booked = 'booked';
  static const String rented = 'rented';

  static const Map<String, String> descriptions = {
    available: 'Tersedia',
    booked: 'Dibooking',
    rented: 'Aktif Dipinjam',
  };

  static String getDescription(String status) {
    return descriptions[status] ?? 'Unknown';
  }
}

class RentStatus {
  static const String pending = 'pending';
  static const String rejected = 'rejected';
  static const String approved = 'approved';
  static const String tracked = 'tracked';
  static const String done = 'done';
  static const String cancelled = 'cancelled';

  static const Map<String, String> descriptions = {
    pending: 'Mengunggu Persetujuan',
    rejected: 'Ditolak',
    approved: 'Disetujui',
    tracked: 'Dilacak',
    done: 'Selesai',
    cancelled: 'Dibatalkan',
  };

  static const Map<String, Color> colors = {
    pending: AppPalette.pendingColor,
    rejected: AppPalette.rejectedColor,
    approved: AppPalette.approvedColor,
    tracked: AppPalette.trackedColor,
    done: AppPalette.doneColor,
    cancelled: AppPalette.cancelledColor,
  };

  static String getDescription(String? status) {
    return descriptions[status] ?? 'Unknown';
  }

  static Color getColor(String? status) {
    return colors[status] ?? Colors.grey;
  }
}
