import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/common/widgets/reload_data.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/services/local_storage_service.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/rent_calculator.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/car/car_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/history_page.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/cards/current_month_rents_card.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/cards/latest_rent_card.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/lists/car_list.dart';

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
    final hideLatestRentCard = await _localStorageService.getHideLatestRentCard();
    setState(() {
      _hideLatestRentCard = hideLatestRentCard;
    });
  }

  void _initPageData() {
    final authData = context.read<AppUserCubit>().state as AppUserLoggedIn;
    context.read<RentBloc>().add(RentGetAllStatsRent(userId: authData.user.id));
    context.read<CarBloc>().add(GetAllCarsEvent());

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
                              latestRent?.status == RentStatus.pending || latestRent?.status == RentStatus.approved,
                        ),
                        SizedBox(height: 24.h),
                        if (latestRent != null && latestRent.status != RentStatus.done && !_hideLatestRentCard) ...[
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
                          final authData = context.read<AppUserCubit>().state as AppUserLoggedIn;
                          context.read<RentBloc>().add(RentGetAllStatsRent(userId: authData.user.id));
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
                            context.read<CarBloc>().add(GetAllCarsEvent());
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
