import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/date_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormDatePickerRangeField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool required;
  final void Function(PickerDateRange?) onDateSelected;

  const FormDatePickerRangeField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.required = false,
    required this.onDateSelected,
  });

  @override
  State<FormDatePickerRangeField> createState() => _FormDatePickerRangeFieldState();
}

class _FormDatePickerRangeFieldState extends State<FormDatePickerRangeField> {
  PickerDateRange? selectedRange;
  String _rangeText = "";

  String? _defaultValidator(String? value) {
    if (widget.required && (value == null || value.isEmpty)) {
      return '${widget.labelText} tidak boleh kosong';
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

  void _onDateSelected(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        String startDateText = args.value.startDate != null
            ? (args.value.startDate as DateTime).toddMMMMyyyyShort()
            : "";

        String endDateText =
            args.value.endDate != null ? (args.value.endDate as DateTime).toddMMMMyyyyShort() : "";

        _rangeText = "$startDateText - $endDateText";

        selectedRange = args.value;
      }
    });
  }

  void _selectDateRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: Dialog(
            alignment: Alignment.center,
            child: Column(
              children: [
                DatePicker(
                  selectedRange: selectedRange,
                  onDateSelected: _onDateSelected,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: BasicAppButton(
                    onPressed: () {
                      print("Selected Range: $selectedRange");
                      widget.onDateSelected(selectedRange);
                      widget.controller.text = _rangeText;
                      Navigator.of(context).pop();
                    },
                    title: 'Pilih',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
          ),
          SizedBox(height: 4.h),
        ],
        GestureDetector(
          onTap: () => _selectDateRange(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.controller,
              validator: _combinedValidator,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
              ),
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
