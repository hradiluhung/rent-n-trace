import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4.r),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(),
          errorBorder: _border(AppPallete.errorColor),
          filled: true,
          fillColor: AppPallete.whiteColor,
        ),
        menuStyle: MenuStyle(
          alignment: Alignment.centerLeft,
          backgroundColor: WidgetStateProperty.all(AppPallete.primaryColor1),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 8.h)),
        )),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(AppPallete.errorColor),
      filled: true,
      fillColor: AppPallete.whiteColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppPallete.primaryColor1,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppPallete.headlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 72.sp,
        height: 78.sp / 72.sp,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: AppPallete.headlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 36.sp,
        height: 42.sp / 36.sp,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: AppPallete.headlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 24.sp,
        height: 32.sp / 24.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: AppPallete.headlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 24.sp,
        height: 32.sp / 24.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: AppPallete.headlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 20.sp,
        height: 26.sp / 20.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: AppPallete.headlineTextColor,
        fontFamily: "TASAOrbiterDisplay",
        fontSize: 12.sp,
        height: 18.sp / 12.sp,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppPallete.bodyTextColor,
        fontSize: 20.sp,
        height: 28.sp / 20.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppPallete.bodyTextColor,
        fontSize: 16.sp,
        height: 24.sp / 16.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppPallete.smallTextColor,
        fontSize: 12.sp,
        height: 16.sp / 12.sp,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        color: AppPallete.bodyTextColor,
        fontSize: 14.sp,
        height: 24.sp / 16.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppPallete.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppPallete.whiteColor,
      selectedItemColor: AppPallete.primaryColor1,
      unselectedItemColor: AppPallete.bodyTextColor,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(AppPallete.primaryOverlayColor),
      ),
    ),
  );
}

extension CustomStyle on TextTheme {
  TextStyle get buttonPrimary => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w600,
        color: AppPallete.whiteColor,
      );

  TextStyle get buttonSecondary => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w600,
        color: AppPallete.secondaryButtonTextColor,
      );

  TextStyle get buttonTetriary => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w600,
        color: AppPallete.secondaryButtonTextColor,
      );

  TextStyle get hintMedium => TextStyle(
        fontSize: 14.sp,
        height: 20.sp / 14.sp,
        fontWeight: FontWeight.w400,
        color: AppPallete.hintTextColor,
      );
}
