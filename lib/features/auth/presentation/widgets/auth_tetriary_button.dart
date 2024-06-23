import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class AuthTetriaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const AuthTetriaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: AppPallete.transparentColor,
        border: Border.all(
          color: AppPallete.borderColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: ElevatedButton.icon(
        icon: icon != null
            ? Icon(
                icon,
                color: AppPallete.bodyTextColor,
              )
            : null,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395.w, 36.h),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.buttonTetriary,
        ),
      ),
    );
  }
}
