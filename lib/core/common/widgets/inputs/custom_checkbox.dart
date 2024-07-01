import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final String labelText;
  final ValueChanged<bool?> onChanged;
  final bool isRequired;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.labelText,
    required this.onChanged,
    this.isRequired = false,
  });

  String? _defaultValidator(bool value) {
    if (isRequired && !value) {
      return '$labelText harus dicentang';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppPalette.primaryColor2,
              checkColor: Colors.white,
            ),
            Text(
              labelText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (_defaultValidator(value) != null)
          Padding(
            padding: EdgeInsets.only(left: 48.0.w),
            child: Text(
              _defaultValidator(value)!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppPalette.errorColor,
                  ),
            ),
          ),
      ],
    );
  }
}
