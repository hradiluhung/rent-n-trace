import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/location/location_bloc.dart';

class TrackingPage extends StatefulWidget {
  static route(String rentId) =>
      MaterialPageRoute(builder: (context) => TrackingPage(rentId: rentId));

  final String rentId;
  const TrackingPage({super.key, required this.rentId});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<LocationBloc>()
        .add(LocationGetRealTimeLocation(widget.rentId));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Column(
        children: [Text("halo")],
      )),
    );
  }
}
