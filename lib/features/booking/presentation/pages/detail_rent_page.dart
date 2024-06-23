import 'package:flutter/material.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';

class DetailRentPage extends StatelessWidget {
  static route(Rent rent) =>
      MaterialPageRoute(builder: (context) => DetailRentPage(rent: rent));

  final Rent rent;
  const DetailRentPage({super.key, required this.rent});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
