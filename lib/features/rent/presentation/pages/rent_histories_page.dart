import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/config/assets/app_images.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_all_rent_histories_cubit.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_all_rent_histories_state.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_history_list.dart';

class RentHistoriesPage extends StatelessWidget {
  const RentHistoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Text("Riwayat Peminjaman",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.foreground,
                )),
      ),
      body: BlocProvider(
        create: (context) => DisplayAllRentHistoriesCubit()..displayRentHistories(),
        child: BlocBuilder<DisplayAllRentHistoriesCubit, DisplayAllRentHistoriesState>(
          builder: (context, state) {
            if (state is DisplayRentHistoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DisplayRentHistoriesLoaded) {
              final groupedHistories = groupRentHistoriesByTimePeriod(state.rentHistories);
              final isEmpty =
                  groupedHistories.isEmpty || groupedHistories.values.every((list) => list.isEmpty);

              if (!isEmpty) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: RentHistoryList(
                    groupedHistories: groupedHistories,
                  ),
                );
              }

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.emptyData,
                        height: 100.h,
                      ),
                      SizedBox(height: 16.h),
                      const Text(
                        "Belum ada data peminjaman",
                        textAlign: TextAlign.center,
                      )
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
}
