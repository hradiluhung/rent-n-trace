import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class DividerText extends StatelessWidget {
  final String text;
  const DividerText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 36.w),
            child: const Divider(
              color: AppPallete.borderColor,
              thickness: 1,
            ),
          ),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 36.w),
            child: const Divider(
              color: AppPallete.borderColor,
              thickness: 1,
            ),
          ),
        ),
      ],
    );
  }
}
