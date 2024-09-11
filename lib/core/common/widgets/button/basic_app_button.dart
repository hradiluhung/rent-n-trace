import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

enum ButtonVariant { defaultVariant, outline, ghost }

class BasicAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Widget? content;
  final double? height;
  final double? width;
  final ButtonVariant variant;
  final bool disabled;

  const BasicAppButton({
    this.onPressed,
    this.title = '',
    this.height,
    this.width,
    this.content,
    this.variant = ButtonVariant.defaultVariant,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == ButtonVariant.outline) {
      return OutlinedButton(
        onPressed: !disabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 50),
        ),
        child: content ??
            Text(
              title,
              style: const TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w500),
            ),
      );
    } else if (variant == ButtonVariant.ghost) {
      return TextButton(
        onPressed: !disabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 50),
        ),
        child: content ??
            Text(
              title,
              style: const TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w500),
            ),
      );
    } else {
      return ElevatedButton(
        onPressed: !disabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 50),
        ),
        child: content ??
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
      );
    }
  }
}
