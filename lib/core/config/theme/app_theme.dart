import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

class AppTheme {
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
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      headlineSmall: GoogleFonts.workSans(
        fontSize: 14.sp,
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
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        disabledForegroundColor: AppColors.foreground.withOpacity(0.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: AppColors.foreground.withOpacity(0.3),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.border,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.foreground.withOpacity(0.4),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.error.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      fillColor: Colors.white70,
      filled: true,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: AppColors.dialogBackground,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.selected)) {
          return AppColors.secondBackground;
        }
        return AppColors.primary;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.background,
      elevation: 10,
    ),
  );
}
