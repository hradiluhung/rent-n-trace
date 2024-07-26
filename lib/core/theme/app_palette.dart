import 'package:flutter/material.dart';

class AppPalette {
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color greyColor = Color(0xFF6C849D);
  static const Color secondaryButtonTextColor = Color(0xFF40566D);

  static const Color backgroundColor = Color(0xFFF1FFED);
  static const Color primaryColor1 = Color(0xFFBEF2B7);
  static const Color primaryColor2 = Color(0xFF33CC5E);
  static const Color primaryColor3 = Color(0xFF009C5C);
  static const Color primaryColor4 = Color(0xFF004231);
  static const Color darkHeadlineTextColor = Color(0xFF111218);
  static const Color lightHeadlineTextColor = Color(0xFFBEF2B7);
  static const Color bodyTextColor = Color(0xFF62636A);
  static const Color bodyTextColor2 = Color(0xFF40566D);
  static const Color smallTextColor = Color(0xFF62636A);
  static const Color borderColor = Color(0xFFB1C1D2);
  static const Color hintTextColor = Color(0x516C849D);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color errorColor2 = Color(0xFFDE4040);
  static const Color warningColor = Color(0xFFC65C10);
  static const Color errorSurfaceColor = Color(0xFFFFE3E3);
  static const Color transparentColor = Color(0x00000000);
  static const Color halfTransparentColor = Color(0x7E000000);
  static const Color shadowColor = Color(0x1E192839);

  static const Color activeTabColor = Color(0xFF192839);

  // status colors
  static const Color pendingColor = Color(0xFFFFB302);
  static const Color rejectedColor = errorColor;
  static const Color approvedColor = primaryColor3;
  static const Color trackedColor = Color(0xFF2DCCFF);
  static const Color doneColor = primaryColor3;
  static const Color cancelledColor = Color(0xFFA4ABB6);
}

class AppBoxShadow {
  static final myBoxShadow = BoxShadow(
    color: AppPalette.greyColor.withOpacity(0.2),
    blurRadius: 15,
    offset: const Offset(0, 2),
  );
}
