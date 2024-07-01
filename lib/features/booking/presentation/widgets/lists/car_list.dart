import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/custom_shimmer_effect.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/cards/car_card.dart';

class CarList extends StatelessWidget {
  final List<Car> cars;

  const CarList({
    super.key,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}

class SkeletonCarList extends StatelessWidget {
  const SkeletonCarList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: CustomShimmerEffect(
        child: Row(
          children: [
            for (int i = 0; i < 3; i++)
              Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 16.w : 0,
                  right: 16.w,
                ),
                child: const CarCardSkeleton(),
              ),
          ],
        ),
      ),
    );
  }
}
