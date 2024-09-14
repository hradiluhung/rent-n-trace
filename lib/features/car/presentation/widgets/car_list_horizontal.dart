import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_card.dart';

class CarListHorizontal extends StatelessWidget {
  final List<Car> cars;
  const CarListHorizontal({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: Text(
            'Mobil Tersedia',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.foreground,
                ),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 190.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cars
                .map((car) => Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: cars.indexOf(car) == 0 ? 16.w : 0,
                          right: 16.w,
                        ),
                        child: CarCard(car: car),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
