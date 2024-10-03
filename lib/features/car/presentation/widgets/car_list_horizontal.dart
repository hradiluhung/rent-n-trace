import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_status_card.dart';

class CarListHorizontal extends StatelessWidget {
  final List<Car> cars;
  const CarListHorizontal({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    child: CarStatusCard(car: car),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
