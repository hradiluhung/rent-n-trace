import 'package:flutter/material.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';

class DetailCarPage extends StatelessWidget {
  static route(Car car) =>
      MaterialPageRoute(builder: (context) => DetailCarPage(car: car));

  final Car car;
  const DetailCarPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(car.name),
            Text(car.status),
          ],
        ),
      ),
    );
  }
}
