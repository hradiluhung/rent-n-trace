import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/widgets/app_skeleton.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/logo.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_list_horizontal.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_all_cars_cubit.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_all_cars_state.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_rent_stats_cubit.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_rent_stats_state.dart';
import 'package:rent_n_trace/features/home/presentation/widgets/curr_month_rents_card.dart';
import 'package:rent_n_trace/features/home/presentation/widgets/latest_rent_card.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_cubit.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        hideBack: true,
        title: Logo(),
      ),
      body: BlocProvider(
        create: (context) => DislayRentStatsCubit()..displayCurrentRents(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _welcomeText(context),
              SizedBox(height: 24.h),
              _stats(),
              SizedBox(height: 24.h),
              _cars(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeText(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is! UserAuthenticated) {
          return const SizedBox.shrink();
        }

        final user = state.user;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Selamat datang kembali, ${user.fullName.split(" ").first}!",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.foreground,
                ),
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }

  Widget _stats() {
    return BlocBuilder<DislayRentStatsCubit, DislayRentStatsState>(
      builder: (context, state) {
        if (state is DislayRentStatsLoading) {
          return AppSkeleton(
            child: CurrMonthRentsCard(
              currentMonthRents: List.generate(3, (index) => state.placeholder),
              latestRent: null,
            ),
          );
        }

        if (state is DislayRentStatsLoaded) {
          final latestRent = state.latestRent;
          final currMonthRents = state.currentMonthRents;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CurrMonthRentsCard(
                currentMonthRents: currMonthRents,
                latestRent: latestRent,
              ),
              if (latestRent != null && latestRent.status != RentStatus.completed) ...[
                SizedBox(height: 24.h),
                LatestRentCard(latestRent: latestRent),
              ]
            ],
          );
        }

        if (state is DislayRentStatsFailed) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _cars(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilihan Mobil',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.foreground,
                    ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Lihat semua mobil di halaman daftar mobil.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                    ),
              )
            ],
          ),
        ),
        SizedBox(height: 16.h),
        BlocBuilder<DisplayAllCarsCubit, DisplayAllCarsState>(
          builder: (context, state) {
            if (state is DisplayCarsLoading) {
              return AppSkeleton(
                child: CarListHorizontal(
                  cars: List.generate(4, (index) => state.placeholder),
                ),
              );
            }

            if (state is DisplayCarsLoaded) {
              return CarListHorizontal(cars: state.cars.take(4).toList());
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
