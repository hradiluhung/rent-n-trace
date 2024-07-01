import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class FormTextareaField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool isRequired;
  final TextInputAction textInputAction;

  const FormTextareaField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.maxLines = 5,
    this.validator,
    this.isRequired = false,
    this.textInputAction = TextInputAction.next,
  });

  String? _defaultValidator(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$labelText tidak boleh kosong';
    }
    return null;
  }

  String? _combinedValidator(String? value) {
    final defaultValidation = _defaultValidator(value);
    if (defaultValidation != null) {
      return defaultValidation;
    }
    if (validator != null) {
      return validator!(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.hintMedium,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppPalette.bodyTextColor,
                  )
                : null,
          ),
          validator: _combinedValidator,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
          style: Theme.of(context).textTheme.bodyMedium,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
