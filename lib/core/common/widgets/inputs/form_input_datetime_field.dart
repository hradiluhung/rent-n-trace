import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/secondary_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormRangeDateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool isRequired;
  final void Function(PickerDateRange?) onDateSelected;

  const FormRangeDateInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.validator,
    this.isRequired = false,
    required this.onDateSelected,
  });

  @override
  FormRangeDateInputFieldState createState() => FormRangeDateInputFieldState();
}

class FormRangeDateInputFieldState extends State<FormRangeDateInputField> {
  PickerDateRange? selectedRange;
  String _rangeText = "";

  String? _defaultValidator(String? value) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
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

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _rangeText =
            '${DateFormat('dd MMMM yyyy', 'id_ID').format(args.value.startDate)} -'
            ' ${DateFormat('dd MMMM yyyy', 'id_ID').format(args.value.endDate ?? args.value.startDate)}';
        selectedRange = args.value;
      }
    });
  }

  void _selectDateRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: SingleChildScrollView(
          child: Dialog(
            backgroundColor: AppPallete.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: selectedRange,
                    backgroundColor: AppPallete.backgroundColor,
                    rangeSelectionColor: AppPallete.primaryColor4,
                    startRangeSelectionColor: AppPallete.primaryColor1,
                    endRangeSelectionColor: AppPallete.primaryColor1,
                    todayHighlightColor: AppPallete.primaryColor1,
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      backgroundColor: AppPallete.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SecondaryButton(
                          text: "Batal",
                          onPressed: () {
                            selectedRange = null;
                            widget.controller.clear();
                            Navigator.of(context).pop();
                          }),
                      SizedBox(width: 8.w),
                      PrimaryButton(
                        text: "Pilih",
                        onPressed: () {
                          widget.onDateSelected(selectedRange);
                          Navigator.of(context).pop();
                          widget.controller.text = _rangeText;
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
        Text(
          widget.labelText,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _selectDateRange(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.hintMedium,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: AppPallete.bodyTextColor,
                      )
                    : null,
              ),
              validator: _combinedValidator,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
