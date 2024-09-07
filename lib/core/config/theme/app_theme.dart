import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

class AppTheme {
  // static _border([Color color = const Color(0xffd1d5db)]) => OutlineInputBorder(
  //       borderSide: BorderSide(
  //         color: color,
  //         width: 1,
  //       ),
  //       borderRadius: BorderRadius.circular(16.r),
  //     );

  static final appTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.workSans(
        fontSize: 24.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
      bodyMedium: GoogleFonts.workSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
      bodySmall: GoogleFonts.workSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
      headlineLarge: GoogleFonts.workSans(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      headlineMedium: GoogleFonts.workSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      headlineSmall: GoogleFonts.workSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.secondBackground,
      contentTextStyle: TextStyle(color: AppColors.foreground),
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //   contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    //   border: _border(),
    //   enabledBorder: _border(),
    //   focusedBorder: _border(),
    //   errorBorder: _border(const Color(0xFFE57373)),
    //   filled: true,
    //   disabledBorder: _border(const Color(0xFFE0E0E0)),
    //   fillColor: AppColors.background,
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ),
  );
}
