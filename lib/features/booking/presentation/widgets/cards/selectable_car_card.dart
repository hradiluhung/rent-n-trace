import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';

class SelectableCarCard extends StatefulWidget {
  final Car car;
  final bool isDisabled;
  final bool isSelected;
  final void Function(Car)? onClick;

  const SelectableCarCard({
    super.key,
    required this.car,
    required this.isDisabled,
    required this.isSelected,
    this.onClick,
  });

  @override
  State<SelectableCarCard> createState() => _SelectableCarCardState();
}

class _SelectableCarCardState extends State<SelectableCarCard> {
  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(
            "Detail Mobil",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.car.images.isNotEmpty && widget.car.images[0] != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.network(
                      widget.car.images[0]!,
                      height: 120.h,
                      width: 160.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              Text(widget.car.name,
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 8.h),
              Text("Jenis Bensin: ${widget.car.fuelType}"),
              Text("Konsumsi Bensin: ${widget.car.fuelConsumption}"),
              SizedBox(height: 8.h),
              Container(
                  decoration: BoxDecoration(
                    color: widget.car.status == CarStatus.available
                        ? AppPalette.primaryColor2
                        : AppPalette.greyColor,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.car.status == CarStatus.available
                            ? EvaIcons.checkmarkCircle2Outline
                            : EvaIcons.closeCircleOutline,
                        color: widget.car.status == CarStatus.available
                            ? AppPalette.whiteColor
                            : AppPalette.bodyTextColor2,
                        size: 14.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        CarStatus.getDescription(widget.car.status),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.car.status == CarStatus.available
                                  ? AppPalette.whiteColor
                                  : AppPalette.bodyTextColor2,
                            ),
                      ),
                    ],
                  ))
            ],
          ),
          actions: [
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppPalette.greyColor),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                EvaIcons.close,
                color: AppPalette.bodyTextColor,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isDisabled ? null : () => widget.onClick?.call(widget.car),
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        width: 164.w,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? AppPalette.primaryColor4
              : widget.isDisabled
                  ? AppPalette.greyColor
                  : AppPalette.primaryColor1,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.car.images.isNotEmpty && widget.car.images[0] != null)
                Center(
                  child: Image.network(
                    widget.car.images[0]!,
                    height: 90.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.car.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: widget.isSelected
                                    ? AppPalette.whiteColor
                                    : widget.isDisabled
                                        ? AppPalette.bodyTextColor2
                                        : AppPalette.primaryColor4,
                                overflow: TextOverflow.ellipsis,
                              ),
                      maxLines: 1,
                    ),
                    Text(
                      CarStatus.getDescription(widget.car.status),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: widget.isSelected
                                ? AppPalette.whiteColor
                                : AppPalette.bodyTextColor2,
                          ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => showInfoDialog(),
                        icon: Icon(
                          EvaIcons.infoOutline,
                          color: widget.isSelected
                              ? AppPalette.whiteColor
                              : AppPalette.primaryColor4,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
