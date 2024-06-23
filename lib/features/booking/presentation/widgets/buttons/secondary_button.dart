import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDisabled;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: AppPallete.transparentGreyColor,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(isFullWidth ? 395.w : double.infinity, 36.h),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
        icon: icon != null
            ? Icon(
                icon,
                color: AppPallete.secondaryButtonTextColor
                    .withOpacity(isDisabled ? 0.5 : 1.0),
              )
            : null,
        label: Text(
          text,
          style: Theme.of(context).textTheme.buttonSecondary.copyWith(
                color: AppPallete.secondaryButtonTextColor
                    .withOpacity(isDisabled ? 0.5 : 1.0),
              ),
        ),
      ),
    );
  }
}
