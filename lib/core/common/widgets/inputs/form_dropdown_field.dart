import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class FormDropdownField extends StatelessWidget {
  final SingleValueDropDownController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool isRequired;
  final List<DropDownValueModel> items;
  final String? Function(String?)? validator;

  const FormDropdownField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.isRequired = false,
    required this.items,
    this.validator,
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
        DropDownTextField(
          textFieldDecoration: InputDecoration(
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
          dropdownRadius: 4.r,
          controller: controller,
          dropDownList: items,
          listTextStyle: Theme.of(context).textTheme.bodyMedium,
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppPalette.bodyTextColor),
          clearIconProperty: IconProperty(
            icon: EvaIcons.close,
            color: AppPalette.bodyTextColor,
          ),
          dropDownIconProperty: IconProperty(
            icon: EvaIcons.chevronDownOutline,
            color: AppPalette.bodyTextColor,
          ),
        ),
      ],
    );
  }
}
