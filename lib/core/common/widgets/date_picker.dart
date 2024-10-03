import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatelessWidget {
  final PickerDateRange? selectedRange;
  final void Function(DateRangePickerSelectionChangedArgs args) onDateSelected;

  const DatePicker({super.key, required this.selectedRange, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(context),
        _datePicker(context),
        _footer(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8.w, left: 16.w, top: 8.h, bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Pilih Tanggal",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.foreground,
                  )),
          IconButton(
            icon: const Icon(LucideIcons.x),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return SizedBox(height: 16.h);
  }

  Widget _datePicker(BuildContext context) {
    return SfDateRangePicker(
      initialSelectedRange: selectedRange,
      onSelectionChanged: onDateSelected,
      selectionMode: DateRangePickerSelectionMode.range,
      backgroundColor: AppColors.dialogBackground,
      headerStyle: DateRangePickerHeaderStyle(
        backgroundColor: AppColors.dialogBackground,
        textAlign: TextAlign.center,
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      rangeSelectionColor: AppColors.primary.withOpacity(0.3),
      startRangeSelectionColor: AppColors.primary,
      endRangeSelectionColor: AppColors.primary,
      todayHighlightColor: AppColors.foreground,
    );
  }
}
