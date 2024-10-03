import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppAlertVariant { info, warning, error }

class AppAlert extends StatelessWidget {
  final IconData icon;
  final String message;
  final AppAlertVariant variant;
  final Widget? actions;

  AppAlert({
    super.key,
    required this.icon,
    required this.message,
    required this.variant,
    this.actions,
  });

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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color[variant]),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color[variant]),
                ),
              ),
            ],
          ),
          if (actions != null) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                actions!,
              ],
            ),
          ],
        ],
      ),
    );
  }
}
