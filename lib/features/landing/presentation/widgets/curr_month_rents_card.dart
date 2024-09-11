import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/rent/presentation/pages/rent_create_page.dart';

class CurrMonthRentsCard extends StatelessWidget {
  final List<RentHistory> currentMonthRents;
  final Rent? latestRent;

  const CurrMonthRentsCard({super.key, required this.currentMonthRents, required this.latestRent});

  @override
  Widget build(BuildContext context) {
    final double totalCost =
        currentMonthRents.fold(0.0, (previousValue, element) => previousValue + element.fuelCost);
    final mostCar = getMostFrequentCarName(currentMonthRents);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardTitle(context),
            SizedBox(height: 10.h),
            _stats(context, currentMonthRents.length, totalCost, mostCar),
            SizedBox(height: 5.h),
            Divider(color: AppColors.secondBackground.withOpacity(0.5)),
            SizedBox(height: 5.h),
            _latestRent(context, latestRent),
          ],
        ),
      ),
    );
  }

  Widget _cardTitle(BuildContext context) {
    return Text(
      'Statistik ${DateTime.now().toMMMMyyyy()}',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.secondBackground,
          ),
    );
  }

  Widget _stats(BuildContext context, int rentLength, double totalCost, String? mostCar) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jumlah Pinjam',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondBackground,
                    ),
              ),
              Text(
                "$rentLength",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 64.sp,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Pengeluaran',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondBackground,
                    ),
              ),
              Text(
                formatToRupiah(totalCost),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              SizedBox(height: 10.h),
              Text(
                'Paling Sering Dipinjam',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondBackground,
                    ),
              ),
              Text(
                mostCar ?? '-',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _latestRent(BuildContext context, Rent? latestRent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terakhir Pinjam",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                latestRent?.createdAt.toddMMMMyyyy() ?? '-',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        BasicAppButton(
          onPressed: () {
            AppNavigator.push(context, const RentCreatePage());
          },
          title: "Booking",
          width: 100.w,
          height: 40.h,
          disabled: latestRent?.status != RentStatus.completed ||
              latestRent?.status == RentStatus.rejected,
        )
      ],
    );
  }
}
