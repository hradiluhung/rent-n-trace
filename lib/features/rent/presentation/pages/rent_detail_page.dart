import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/helpers/extension/string_extension.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/user_avatar.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_cubit.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_state.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_status_badge.dart';
import 'package:rent_n_trace/features/tracking/presentation/pages/tracking_page.dart';

class RentDetailPage extends StatelessWidget {
  final String id;
  const RentDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplayDetailRentCubit()..displayDetailRent(id),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text("Detail Peminjaman", style: Theme.of(context).textTheme.headlineMedium),
        ),
        bottomNavigationBar: BlocBuilder<DisplayDetailRentCubit, DisplayDetailRentState>(
          builder: (context, state) {
            if (state is DisplayDetailRentLoaded &&
                (state.rent.status == RentStatus.approved ||
                    state.rent.status == RentStatus.tracked)) {
              return Container(
                padding: EdgeInsets.all(16.r),
                child: BasicAppButton(
                  onPressed: () {
                    AppNavigator.push(context, TrackingPage(rent: state.rent));
                  },
                  title: state.rent.status == RentStatus.approved
                      ? "Mulai Perjalanan"
                      : "Lacak Lokasi",
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        body: BlocBuilder<DisplayDetailRentCubit, DisplayDetailRentState>(
          builder: (context, state) {
            if (state is DisplayDetailRentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DisplayDetailRentLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      _detailRent(context, state.rent),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _detailRent(BuildContext context, Rent rent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _carCard(context, rent),
        if (rent.driverId != null) ...[
          SizedBox(height: 8.h),
          _driverCard(context, rent),
        ],
        SizedBox(height: 16.h),
        _otherDetail(context, rent),
      ],
    );
  }

  Widget _driverCard(BuildContext context, Rent rent) {
    return Card(
      elevation: 0,
      color: AppColors.secondBackground,
      child: Container(
        padding: EdgeInsets.all(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatar(name: rent.driverName!, imageUrl: rent.driverPhoto),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Supir",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  rent.driverName!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.foreground,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _carCard(BuildContext context, Rent rent) {
    return Card(
      elevation: 0,
      color: AppColors.darkBackground,
      child: Container(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Image.network(
              rent.carImage!,
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mobil",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    rent.carName!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    rent.carFuelType!.capitalize(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    rent.carFuelConsumption!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherDetail(BuildContext context, Rent rent) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rentData(
            "Tanggal Peminjaman",
            Text(
              "${rent.startDate.toddMMMMyyyy()} - ${rent.endDate.toddMMMMyyyy()}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          _rentData(
            "Kebutuhan",
            Text(
              rent.need,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          _rentData(
            "Detail Kebutuhan",
            Text(
              rent.needDetail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          _rentData(
            "Tujuan",
            Text(
              rent.destination,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          _rentData(
            "Status",
            RentStatusBadge(rentStatus: rent.status),
          ),
        ],
      ),
    );
  }

  Widget _rentData(String label, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        value,
      ],
    );
  }
}
