import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/detail_rent_page.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/tags/rent_status_tags.dart';

class HistoryPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const HistoryPage());
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    final authData = context.read<AppUserCubit>().state as AppUserLoggedIn;
    context.read<RentBloc>().add(RentGetAllUserRents(userId: authData.user.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
      ),
      body: BlocBuilder<RentBloc, RentState>(
        builder: (context, state) {
          if (state is RentLoading) return const LinearProgressIndicator();

          if (state is RentMultipleRentsLoaded) {
            final groupedRents = groupBookings(state.rents);
            final approvedRents = groupedRents["approved"];
            final nonApprovedRents = groupedRents["nonApproved"];

            return Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (approvedRents != null &&
                          approvedRents.isNotEmpty) ...[
                        Text(
                          "Peminjaman Mendatang",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8.h),
                        for (var rent in approvedRents["approved"]!)
                          Column(
                            children: [
                              RentCard(
                                rent: rent,
                                onClick: () => {
                                  Navigator.push(
                                      context, DetailRentPage.route(rent)),
                                },
                              ),
                              SizedBox(height: 8.h),
                            ],
                          ),
                        SizedBox(height: 16.h)
                      ],
                      if (nonApprovedRents != null &&
                          nonApprovedRents.isNotEmpty) ...[
                        Text(
                          "Peminjaman Lampau",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8.h),
                        for (var month in nonApprovedRents.keys)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                month,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                    ),
                              ),
                              for (var rent in nonApprovedRents[month]!)
                                Column(
                                  children: [
                                    RentCard(
                                      rent: rent,
                                      onClick: () => {
                                        Navigator.push(context,
                                            DetailRentPage.route(rent)),
                                      },
                                    ),
                                    SizedBox(height: 8.h),
                                  ],
                                ),
                            ],
                          ),
                      ],
                      // If there is no rent
                      if (approvedRents == null ||
                          approvedRents.isEmpty && nonApprovedRents == null ||
                          nonApprovedRents!.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 16.h),
                              Text(
                                "Tidak ada riwayat peminjaman",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class RentCard extends StatelessWidget {
  final Rent rent;
  final Function()? onClick;
  const RentCard({super.key, required this.rent, this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppPalette.greyColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        width: double.infinity,
        child: Row(
          children: [
            Image.network(
              rent.carImage!,
              width: 120.w,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rent.carName!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${rent.startDateTime.toFormattedddMMMMyyyy()} - ${rent.endDateTime.toFormattedddMMMMyyyy()}',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RentStatusTags(
                    rentStatus: rent.status!,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, Map<String, List<Rent>>> groupBookings(List<Rent> rents) {
  Map<String, List<Rent>> approvedBookings = {};
  Map<String, List<Rent>> nonApprovedBookings = {};

  for (var rent in rents) {
    if (rent.status == RentStatus.approved ||
        rent.status == RentStatus.pending) {
      if (!approvedBookings.containsKey("approved")) {
        approvedBookings["approved"] = [];
      }
      approvedBookings["approved"]!.add(rent);
    } else {
      String month = DateFormat.yMMM().format(rent.startDateTime);
      if (!nonApprovedBookings.containsKey(month)) {
        nonApprovedBookings[month] = [];
      }
      nonApprovedBookings[month]!.add(rent);
    }
  }

  return {
    "approved": approvedBookings,
    "nonApproved": nonApprovedBookings,
  };
}
