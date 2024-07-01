import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class CustomBackButton extends StatelessWidget {
  final bool isOverDarkBackground;

  const CustomBackButton({super.key, this.isOverDarkBackground = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isOverDarkBackground
            ? AppPalette.greyColor.withOpacity(0.3)
            : AppPalette.greyColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          EvaIcons.chevronLeftOutline,
          size: 32,
          color: isOverDarkBackground
              ? AppPalette.whiteColor
              : AppPalette.bodyTextColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
