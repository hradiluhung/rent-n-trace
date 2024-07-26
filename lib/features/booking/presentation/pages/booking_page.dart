import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/forms/booking_form.dart';

class BookingPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const BookingPage());
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                'Detail Booking (1/2)',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 16.sp,
                    ),
              ),
              Text("Keterangan Peminjaman",
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implements dialog booking info
            },
            icon: const Icon(EvaIcons.infoOutline),
          ),
        ],
      ),
      body: const Scrollbar(
        child: SingleChildScrollView(
          child: BookingForm(),
        ),
      ),
    );
  }
}
