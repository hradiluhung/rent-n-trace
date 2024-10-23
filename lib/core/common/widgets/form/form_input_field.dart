import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

class FormInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int maxLines;
  final bool required;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool readOnly;
  final bool isTriggerBottomSheet;
  final String? name;
  final String? description;

  const FormInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.required = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.isTriggerBottomSheet = false,
    this.name,
    this.focusNode,
    this.nextFocusNode,
    this.description,
  });

  @override
  State<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  String? _defaultValidator(String? value) {
    if (widget.required && (value == null || value.isEmpty)) {
      return '${widget.name ?? widget.labelText} tidak boleh kosong';
    }
    return null;
  }

  String? _combinedValidator(String? value) {
    final defaultValidation = _defaultValidator(value);
    if (defaultValidation != null) {
      return defaultValidation;
    }
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isReadOnly = widget.readOnly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              widget.labelText!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isReadOnly ? AppColors.foreground.withOpacity(0.5) : AppColors.foreground,
              ),
            ),
          ),
          SizedBox(height: 4.h),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          focusNode: widget.focusNode,
          onFieldSubmitted: (value) {
            if (widget.textInputAction == TextInputAction.next && widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
          validator: _combinedValidator,
          readOnly: isReadOnly || widget.isTriggerBottomSheet,
          decoration: InputDecoration(
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder?.copyWith(
                  borderSide: BorderSide(
                    color: isReadOnly ? AppColors.border.withOpacity(0.5) : AppColors.border,
                    width: 1,
                  ),
                ),
            errorMaxLines: 2,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder?.copyWith(
                  borderSide: BorderSide(
                    color: isReadOnly
                        ? AppColors.border.withOpacity(0.5)
                        : AppColors.foreground.withOpacity(0.4),
                    width: 1,
                  ),
                ),
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: isReadOnly ? AppColors.foreground.withOpacity(0.5) : null,
                  )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon != null
                    ? Icon(widget.suffixIcon)
                    : null,
          ),
          maxLines: widget.maxLines,
          style: TextStyle(
            fontSize: 14.sp,
            color: isReadOnly ? AppColors.foreground.withOpacity(0.5) : AppColors.foreground,
          ),
        ),
        if (widget.description != null) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              widget.description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.foreground.withOpacity(0.5),
                  ),
            ),
          ),
        ]
      ],
    );
  }
}
