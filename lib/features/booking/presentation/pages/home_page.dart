import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/tetriary_button.dart';
import 'package:rent_n_trace/core/common/widgets/reload_data.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/constants/swadow_constants.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/calculate_current_month_rent_stats.dart';
import 'package:rent_n_trace/core/utils/local_storage_service.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/car/car_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/detail_rent_page.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/history_page.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/cards/current_month_rents_card.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/lists/car_list.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/tags/rent_status_tags.dart';
import 'package:rent_n_trace/features/tracking/presentation/pages/tracking_page.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentDate = DateTime.now();
  late LocalStorageService _localStorageService;
  late String userFullname;
  bool _hideLatestRentCard = false;

  @override
  void initState() {
    super.initState();

    _localStorageService = LocalStorageService();
    _initPageData();
    _fetchHideLatestRentCard();
  }

  Future<void> _fetchHideLatestRentCard() async {
    final hideLatestRentCard =
        await _localStorageService.getHideLatestRentCard();
    setState(() {
      _hideLatestRentCard = hideLatestRentCard;
    });
  }

  void _initPageData() {
    final authData = context.read<AppUserCubit>().state as AppUserLoggedIn;
    context.read<RentBloc>().add(RentGetAllStatsRent(userId: authData.user.id));
    context.read<CarBloc>().add(CarGetAllCars());

    setState(() {
      userFullname = authData.user.fullName;
    });
  }

  void _toggleLatestRentCardVisibility() async {
    final newValue = !_hideLatestRentCard;
    await _localStorageService.setHideLatestRentCard(newValue);
    setState(() {
      _hideLatestRentCard = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, HistoryPage.route()).then(
                (_) {
                  _initPageData();
                },
              );
            },
            icon: const Icon(
              Icons.history_outlined,
              color: AppPalette.bodyTextColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.r),
          child: Column(
            children: [
              BlocBuilder<RentBloc, RentState>(
                builder: (context, state) {
                  if (state is RentLoading) {
                    return Column(
                      children: [
                        const SkeletonCurrRentCard(),
                        SizedBox(height: 24.h),
                      ],
                    );
                  }

                  if (state is RentAllRentStatsLoaded) {
                    final rents = state.rents;
                    final latestRent = state.latestRent;

                    return Column(
                      children: [
                        CurrentMonthRentsCard(
                          currentMonthYear: currentDate.toFormattedMMMMyyyy(),
                          totalRent: rents.length,
                          estimatedFuelCost: calculateEstimatedFuelCost(rents),
                          mostRentedCar: getMostRentedCar(rents),
                          lastRentedDate: getLastRentedDate(rents),
                          isRentActive:
                              latestRent?.status == RentStatus.pending ||
                                  latestRent?.status == RentStatus.approved,
                        ),
                        SizedBox(height: 24.h),
                        if (latestRent != null &&
                            latestRent.status != RentStatus.done &&
                            !_hideLatestRentCard) ...[
                          LatestRentCard(
                              rent: latestRent,
                              onDismissed: () {
                                _toggleLatestRentCardVisibility();
                              }),
                          SizedBox(height: 24.h),
                        ],
                      ],
                    );
                  }

                  if (state is RentFailure) {
                    return ReloadButton(
                        message: state.message,
                        onPressed: () {
                          final authData = context.read<AppUserCubit>().state
                              as AppUserLoggedIn;
                          context.read<RentBloc>().add(
                              RentGetAllStatsRent(userId: authData.user.id));
                        });
                  }

                  return const SizedBox.shrink();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Mobil Tersedia",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<CarBloc, CarState>(
                    builder: (context, state) {
                      if (state is CarLoading) {
                        return const SkeletonCarList();
                      }

                      if (state is CarAllCarsLoaded) {
                        final cars = state.cars;
                        return CarList(cars: cars);
                      }

                      if (state is CarFailure) {
                        return ReloadButton(
                          message: state.message,
                          onPressed: () {
                            context.read<CarBloc>().add(CarGetAllCars());
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LatestRentCard extends StatelessWidget {
  final Rent rent;
  final void Function() onDismissed;
  const LatestRentCard(
      {super.key, required this.rent, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Booking Anda",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              if (rent.status == RentStatus.cancelled ||
                  rent.status == RentStatus.rejected)
                GestureDetector(
                  onTap: onDismissed,
                  child: const Icon(EvaIcons.close),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppPalette.whiteColor,
              boxShadow: [myBoxShadow],
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              TrackingPage.route(rent.id),
                            );
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
