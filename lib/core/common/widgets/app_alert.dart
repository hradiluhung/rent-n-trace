import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppAlertVariant { info, warning, error }

class AppAlert extends StatelessWidget {
  final IconData icon;
  final String message;
  final AppAlertVariant variant;
  AppAlert({super.key, required this.icon, required this.message, required this.variant});

  final color = {
    AppAlertVariant.info: Colors.blue,
    AppAlertVariant.warning: Colors.orange,
    AppAlertVariant.error: Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color[variant]?[50],
        border: Border.all(color: color[variant]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color[variant]),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "Mobil dibooking bisa tetap tersedia. Sesuaikan dengan tanggal peminjaman.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color[variant]),
            ),
          ),
        ],
      ),
    );
  }
}
