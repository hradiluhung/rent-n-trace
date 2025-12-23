import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/extension/string_extension.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/label_with_value.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/core/secrets/app_secrets.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/bloc/display_detail_car_cubit.dart';
import 'package:rent_n_trace/features/car/presentation/bloc/display_detail_car_state.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_status_badge.dart';

class CarDetailPage extends StatelessWidget {
  final String id;
  const CarDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Detail Mobil",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 20.sp,
                color: AppColors.secondForeground,
              ),
        ),
      ),
      body: BlocProvider(
        create: (context) => DisplayDetailCarCubit()..displayDetailCar(id),
        child: BlocBuilder<DisplayDetailCarCubit, DisplayDetailCarState>(
          builder: (context, state) {
            if (state is DisplayDetailCarStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DisplayDetailCarStateLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(24.r),
                child: _detailCar(state.car),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _detailCar(Car car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _carImage(car.image),
        SizedBox(height: 32.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelWithValue(label: "Nama", value: car.name),
            SizedBox(height: 20.h),
            LabelWithValue(
                label: "Konsumsi Bensin", value: car.fuelConsumption),
            SizedBox(height: 20.h),
            LabelWithValue(
                label: "Tipe Bensin", value: car.fuelType.capitalize()),
            SizedBox(height: 20.h),
            LabelWithValue(
                label: "Status",
                content: CarStatusBadge(carStatus: car.status)),
          ],
        ),
      ],
    );
  }

  Widget _carImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.network(
        "${AppSecrets.supabaseUrl}/$image",
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
