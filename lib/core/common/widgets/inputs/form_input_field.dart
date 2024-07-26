import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class FormInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final bool isObscureText;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isRequired;
  final bool isDisabled;

  const FormInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.isDisabled = false,
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
    final TextStyle enabledTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle disabledTextStyle =
        enabledTextStyle.copyWith(color: AppPalette.greyColor.withOpacity(0.4));

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
                    color: isDisabled
                        ? AppPalette.greyColor.withOpacity(0.4)
                        : AppPalette.bodyTextColor,
                  )
                : null,
          ),
          enabled: !isDisabled,
          validator: _combinedValidator,
          obscureText: isObscureText,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          style: isDisabled ? disabledTextStyle : enabledTextStyle,
        ),
      ],
    );
  }
}
