import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class AppTheme {
  static _border([Color color = AppPalette.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.backgroundColor,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(),
          errorBorder: _border(AppPalette.errorColor),
          filled: true,
          fillColor: AppPalette.whiteColor,
        ),
        menuStyle: MenuStyle(
          alignment: Alignment.centerLeft,
          backgroundColor: WidgetStateProperty.all(AppPalette.primaryColor2),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 8.h)),
        )),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(AppPalette.errorColor),
      filled: true,
      disabledBorder: _border(AppPalette.greyColor.withOpacity(0.3)),
      fillColor: AppPalette.whiteColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppPalette.primaryColor2,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppPalette.darkHeadlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 72.sp,
        height: 78.sp / 72.sp,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: AppPalette.darkHeadlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 36.sp,
        height: 42.sp / 36.sp,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: AppPalette.darkHeadlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 24.sp,
        height: 32.sp / 24.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: AppPalette.darkHeadlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 24.sp,
        height: 32.sp / 24.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: AppPalette.darkHeadlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 20.sp,
        height: 26.sp / 20.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: AppPalette.darkHeadlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppPalette.bodyTextColor,
        fontSize: 20.sp,
        height: 28.sp / 20.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppPalette.bodyTextColor,
        fontSize: 16.sp,
        height: 24.sp / 16.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppPalette.smallTextColor,
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        color: AppPalette.bodyTextColor,
        fontSize: 14.sp,
        height: 24.sp / 16.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppPalette.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppPalette.whiteColor,
      selectedItemColor: AppPalette.primaryColor2,
      unselectedItemColor: AppPalette.bodyTextColor,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor:
            WidgetStateProperty.all(AppPalette.greyColor.withOpacity(0.1)),
      ),
    ),
  );
}

extension CustomStyle on TextTheme {
  TextStyle get buttonPrimary => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w600,
        color: AppPalette.whiteColor,
      );

  TextStyle get buttonSecondary => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w600,
        color: AppPalette.greyColor,
      );

  TextStyle get buttonTetriary => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w600,
        color: AppPalette.greyColor,
      );

  TextStyle get hintMedium => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w400,
        color: AppPalette.hintTextColor,
      );
}
