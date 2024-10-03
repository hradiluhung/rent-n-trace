import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/widgets/app_alert.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_status_card.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_all_cars_cubit.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_all_cars_state.dart';

class CarsPage extends StatelessWidget {
  const CarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Text("Daftar Mobil",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.foreground,
                )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: BlocBuilder<DisplayAllCarsCubit, DisplayAllCarsState>(
          builder: (context, state) {
            if (state is DisplayCarsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DisplayCarsLoaded) {
              return Column(
                children: [
                  AppAlert(
                    icon: LucideIcons.info,
                    message:
                        "Mobil dibooking bisa tetap tersedia. Sesuaikan dengan tanggal peminjaman.",
                    variant: AppAlertVariant.info,
                  ),
                  SizedBox(height: 24.h),
                  _carList(context, state.cars),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _carList(BuildContext context, List<Car> cars) {
    return GridView.builder(
      itemCount: cars.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return CarStatusCard(
          car: cars[index],
        );
      },
    );
  }
}
