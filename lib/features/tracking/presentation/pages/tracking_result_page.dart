import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realm/realm.dart';
import 'package:rent_n_trace/core/common/realm/realm_config.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/distance_calculator.dart';
import 'package:rent_n_trace/features/tracking/data/models/realm/local_locations.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/rent/tracking_rent_bloc.dart';

class TrackingResultPage extends StatefulWidget {
  static route(String rentId) => MaterialPageRoute(builder: (context) => TrackingResultPage(rentId: rentId));

  final String rentId;
  const TrackingResultPage({super.key, required this.rentId});

  @override
  State<TrackingResultPage> createState() => _TrackingResultPageState();
}

class _TrackingResultPageState extends State<TrackingResultPage> with SingleTickerProviderStateMixin {
  Realm realm = RealmConfig().getRealm();
  late AnimationController _controller;
  late Animation<double> _fadeInUpAnimation;

  double distance = 0;

  @override
  void initState() {
    super.initState();

    context.read<TrackingRentBloc>().add(TrackingRentGetByRentIdEvent(widget.rentId));

    final locationData = realm.all<LocalLocations>();
    if (locationData.isNotEmpty) {
      setState(() {
        distance = locationData.first.distance;
      });
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInUpAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrackingRentBloc, TrackingRentState>(
        builder: (context, state) {
          if (state is TrackingRentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrackingRentGetSuccess) {
            return FadeTransition(
              opacity: _controller,
              child: Transform.translate(
                offset: Offset(0, _fadeInUpAnimation.value),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        EvaIcons.checkmarkCircle2Outline,
                        size: 100,
                        color: AppPalette.primaryColor2,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Tracking Selesai",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Jarak perjalanan: ${distance.toStringAsFixed(2)} meter",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      // Estimasi biaya bensin
                      Text(
                        "Estimasi biaya bensin: Rp. ${(meterToKm(distance) * (state.rent.fuelConsumption ?? 0)).toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Kembali"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
