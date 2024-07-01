import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class CircularButton extends StatelessWidget {
  final bool isOverDarkBackground;
  final IconData icon;
  final Function? onClick;

  const CircularButton({
    super.key,
    this.isOverDarkBackground = false,
    required this.icon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () {
        onClick?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isOverDarkBackground
              ? AppPalette.greyColor.withOpacity(0.3)
              : AppPalette.greyColor.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: isOverDarkBackground
                ? AppPalette.whiteColor
                : AppPalette.greyColor.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: isOverDarkBackground
                ? AppPalette.whiteColor
                : AppPalette.bodyTextColor,
          ),
        ),
      ),
    );
  }
}
