import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/logo.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_list_horizontal.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/display_all_cars_cubit.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/display_all_cars_state.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/display_rent_stats_cubit.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/display_rent_stats_state.dart';
import 'package:rent_n_trace/features/landing/presentation/widgets/curr_month_rents_card.dart';
import 'package:rent_n_trace/features/landing/presentation/widgets/latest_rent_card.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/splash_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        hideBack: true,
        title: Logo(),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
          BlocProvider(
            create: (context) => DislayRentStatsCubit()..displayCurrentRents(),
          ),
        ],
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SplashCubit, SplashState>(
                builder: (context, state) {
                  final user = (state as SplashAuthenticated).user;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Selamat datang kembali, ${user.fullName.split(" ").first}!",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  );
                },
              ),
              SizedBox(height: 8.h),
              _stats(),
              SizedBox(height: 16.h),
              _cars(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stats() {
    return BlocBuilder<DislayRentStatsCubit, DislayRentStatsState>(
      builder: (context, state) {
        if (state is DislayRentStatsLoading) {
          // TODO: Replace with skeleton loader
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DislayRentStatsLoaded) {
          final latestRent = state.latestRent;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CurrMonthRentsCard(
                currentMonthRents: state.currentMonthRents,
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

  Widget _cars() {
    return BlocBuilder<DisplayAllCarsCubit, DisplayAllCarsState>(
      builder: (context, state) {
        if (state is DisplayCarsLoading) {
          // TODO: Replace with skeleton loader
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DisplayCarsLoaded) {
          return CarListHorizontal(cars: state.cars);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
