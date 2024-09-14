import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_all_rent_histories_cubit.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_all_rent_histories_state.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_history_list.dart';

class RentHistoryPage extends StatelessWidget {
  const RentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Text("Riwayat Peminjaman", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: BlocProvider(
          create: (context) => DisplayAllRentHistoriesCubit()..displayRentHistories(),
          child: BlocBuilder<DisplayAllRentHistoriesCubit, DisplayAllRentHistoriesState>(
            builder: (context, state) {
              if (state is DisplayRentHistoriesLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DisplayRentHistoriesLoaded) {
                final groupedHistories = groupRentHistoriesByTimePeriod(state.rentHistories);
                return RentHistoryList(groupedHistories: groupedHistories);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
