import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppPallete.primaryColor1,
            AppPallete.primaryColor2,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395.w, 36.h),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.buttonPrimary,
        ),
      ),
    );
  }
}
