import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/constants/statuses.dart';
import 'package:rent_n_trace/core/constants/widget_sizes.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/calculate_current_month_rent_stats.dart';
import 'package:rent_n_trace/core/utils/show_snackbar.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/car/car_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/booking_page.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/detail_rent_page.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/tetriary_button.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/cards/car_card.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/tags/rent_status_tags.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<CarBloc>().add(CarGetAllCars());
    final authData = context.read<AppUserCubit>().state as AppUserLoggedIn;
    context.read<RentBloc>().add(RentGetAllStatsRent(userId: authData.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement navigate to rent history page
            },
            icon: const Icon(EvaIcons.fileTextOutline),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.r),
            child: BlocListener<RentBloc, RentState>(
              listener: (context, state) {
                if (state is RentFailure) {
                  showSnackBar(context, state.message);
                }
              },
              child: Column(
                children: [
                  BlocBuilder<RentBloc, RentState>(
                    builder: (context, state) {
                      if (state is RentGetAllStatsRentSuccess) {
                        final rents = state.rents;
                        final latestRent = state.latestRent;

                        return Column(
                          children: [
                            CurrentMonthRentsCard(
                              currentMonthYear:
                                  currentDate.toFormattedMMMMyyyy(),
                              totalRent: rents.length,
                              estimatedFuelCost:
                                  calculateEstimatedFuelCost(rents),
                              mostRentedCar: getMostRentedCar(rents),
                              lastRentedDate: getLastRentedDate(rents),
                              isRentActive: latestRent != null,
                            ),
                            SizedBox(height: 24.h),
                            if (latestRent != null &&
                                latestRent.status != RentStatus.done) ...[
                              LatestRentCard(rent: latestRent),
                              SizedBox(height: 24.h),
                            ],
                          ],
                        );
                      }

                      if (state is RentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  BlocBuilder<CarBloc, CarState>(
                    builder: (context, state) {
                      if (state is CarGetAllSuccess) {
                        final cars = state.cars;
                        if (cars.isNotEmpty) {
                          return CarList(cars: cars);
                        } else {
                          return const Text(
                              'Tidak ada mobil yang tersedia saat ini.');
                        }
                      }

                      if (state is CarLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.homeOutline),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.carOutline),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.personOutline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class LatestRentCard extends StatelessWidget {
  final Rent rent;
  const LatestRentCard({super.key, required this.rent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Booking Anda",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppPallete.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppPallete.shadowColor,
                  blurRadius: 8.r,
                  offset: Offset(0, 4.r),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (rent.carImage != null)
                            Center(
                              child: Image.network(
                                rent.carImage!,
                                height: 72.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RentStatusTags(rentStatus: rent.status!),
                            SizedBox(height: 4.h),
                            Text(
                              rent.carName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              rent.destination,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${rent.startDateTime.toFormattedddMMMMyyyy()}-${rent.endDateTime.toFormattedddMMMMyyyy()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                  ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TetriaryButton(
                        icon: EvaIcons.infoOutline,
                        text: "Detail",
                        onPressed: () => {
                          Navigator.push(context, DetailRentPage.route(rent)),
                        },
                        widgetSize: WidgetSizes.small,
                      ),
                      if (rent.status == RentStatus.approved) ...[
                        SizedBox(width: 8.w),
                        PrimaryButton(
                          icon: EvaIcons.playCircleOutline,
                          text: "Mulai",
                          onPressed: () => {
                            // TODO: Implement track rent
                          },
                          widgetSize: WidgetSizes.small,
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveBookingCard extends StatelessWidget {
  const ActiveBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sedang Berlangsung",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppPallete.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppPallete.shadowColor,
                  blurRadius: 8.r,
                  offset: Offset(0, 4.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentMonthRentsCard extends StatelessWidget {
  final String currentMonthYear;
  final int totalRent;
  final String estimatedFuelCost;
  final String mostRentedCar;
  final String lastRentedDate;
  final bool isRentActive;

  const CurrentMonthRentsCard({
    super.key,
    required this.currentMonthYear,
    required this.totalRent,
    required this.estimatedFuelCost,
    required this.mostRentedCar,
    required this.lastRentedDate,
    this.isRentActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPallete.primaryColor3,
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: AppPallete.whiteColor,
              fontSize: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistik $currentMonthYear',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppPallete.headlineTextColor2,
                      ),
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppPallete.whiteColor,
                        width: 0.5.h,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah Pinjam',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppPallete.headlineTextColor2,
                                    ),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                totalRent.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: AppPallete.whiteColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimasi Biaya Bensin',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppPallete.headlineTextColor2,
                                    ),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                estimatedFuelCost,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppPallete.whiteColor,
                                    ),
                              ),
                              SizedBox(height: 14.sp),
                              Text(
                                'Paling Sering Dipinjam',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppPallete.headlineTextColor2,
                                    ),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                mostRentedCar,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppPallete.whiteColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: isRentActive
                          ? Text("Anda sedang meminjam mobil",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppPallete.whiteColor,
                                    fontSize: 14.sp,
                                  ))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Terakhir Pinjam",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppPallete.whiteColor,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  lastRentedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppPallete.whiteColor,
                                        fontSize: 14.sp,
                                      ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryButton(
                          icon: EvaIcons.editOutline,
                          onPressed: () =>
                              Navigator.push(context, BookingPage.route()),
                          text: "Booking",
                          isDisabled: isRentActive,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CarList extends StatelessWidget {
  final List<Car> cars;

  const CarList({
    super.key,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: Text(
            "Mobil Tersedia",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < cars.length; i++) ...[
                SizedBox(width: i == 0 ? 16.w : 0),
                CarCard(car: cars[i]),
                SizedBox(width: 16.w),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
