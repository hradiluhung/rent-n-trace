import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';

class RentStatusBadge extends StatelessWidget {
  final String rentStatus;
  final String? additionalText;
  const RentStatusBadge({
    super.key,
    required this.rentStatus,
    this.additionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: RentStatus.getBackgroundColor(rentStatus),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        RentStatus.getDescription(rentStatus),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: RentStatus.getTextColor(rentStatus),
              fontSize: 10.sp,
            ),
      ),
    );
  }
}
