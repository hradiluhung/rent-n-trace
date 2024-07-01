import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class RentStatusTags extends StatelessWidget {
  final String rentStatus;
  final String? additionalText;
  const RentStatusTags({
    super.key,
    required this.rentStatus,
    this.additionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: RentStatus.getColor(rentStatus),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${RentStatus.getDescription(rentStatus)}${additionalText ?? ''}",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppPalette.whiteColor,
              fontSize: 10.sp,
            ),
      ),
    );
  }
}
