import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      return Skeleton.leaf(
        child: OutlinedButton(
          onPressed: !disabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 50),
          ),
          child: content ??
              Text(
                title,
                style: _textStyle(context),
              ),
        ),
      );
    } else if (variant == ButtonVariant.ghost) {
      return Skeleton.leaf(
        child: TextButton(
          onPressed: !disabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 50),
          ),
          child: content ??
              Text(
                title,
                style: _textStyle(context),
              ),
        ),
      );
    } else {
      return Skeleton.leaf(
        child: ElevatedButton(
          onPressed: !disabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width ?? MediaQuery.of(context).size.width, height ?? 50),
          ),
          child: content ??
              Text(
                title,
                style: _textStyle(context),
              ),
        ),
      );
    }
  }

  TextStyle? _textStyle(BuildContext context) {
    Color textColor;

    switch (variant) {
      case ButtonVariant.outline:
        textColor = AppColors.foreground;
        break;
      case ButtonVariant.ghost:
        textColor = AppColors.foreground;
        break;
      default:
        textColor = Colors.white;
    }

    return Theme.of(context).textTheme.titleSmall?.copyWith(color: textColor);
  }
}
