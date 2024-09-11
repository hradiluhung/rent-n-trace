import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';
import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_active_location_cubit.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_active_location_state.dart';

BoxDecoration boxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0x484848).withOpacity(0.24),
      offset: const Offset(0, 5),
      blurRadius: 5,
      spreadRadius: 2,
    )
  ],
);

class TrackingPage extends StatefulWidget {
  final Rent rent;

  const TrackingPage({super.key, required this.rent});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  MapboxMap? mapboxMap;

  @override
  void initState() {
    super.initState();
    checkPemission();
  }

  Future<void> checkPemission() async {
    bool locationDenied = await Permission.location.isDenied;
    if (locationDenied) {
      await Permission.location.request();
    }

    bool locationAlwaysDenied = await Permission.location.isPermanentlyDenied;
    if (locationAlwaysDenied && mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Akses Lokasi Diperlukan"),
            content: const Text(
                "Aplikasi membutuhkan akses lokasi untuk melacak peminjaman. Silakan buka pengaturan dan berikan akses lokasi."),
            actions: [
              BasicAppButton(
                title: "Batal",
                variant: ButtonVariant.outline,
                height: 40.h,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 8.h),
              BasicAppButton(
                title: "Buka Pengaturan",
                height: 40.h,
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));

    const gl.LocationSettings locationSettings = gl.LocationSettings(
      accuracy: gl.LocationAccuracy.high,
      distanceFilter: 100,
    );

    final initialLocation =
        await gl.Geolocator.getCurrentPosition(locationSettings: locationSettings);

    mapboxMap.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(initialLocation.longitude, initialLocation.latitude),
        ),
        zoom: 14.0,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
  }

  void _showDialogStartTracking(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apakah Anda yakin akan memulai perjalanan?",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.foreground,
                    ),
              ),
              SizedBox(height: 16.h),
              BasicAppButton(
                variant: ButtonVariant.outline,
                title: "Tidak",
                height: 40.h,
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  service.invoke('stop-service');
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 8.h),
              BasicAppButton(
                title: "Mulai",
                height: 40.h,
                onPressed: () async {
                  final service = FlutterBackgroundService();

                  service.invoke(
                    'start-tracking',
                    {'rentId': widget.rent.id},
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Track Peminjaman"),
        ),
        body: Stack(
          children: [
            _map(),
            _info(),
          ],
        ),
      ),
    );
  }

  Widget _map() {
    return MapWidget(
      key: const ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
    );
  }

  Widget _info() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Container(
          decoration: boxDecoration,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: BlocProvider(
            create: (context) => DisplayActiveLocationCubit()..displayLocation(widget.rent.id),
            child: BlocBuilder<DisplayActiveLocationCubit, DisplayActiveLocationState>(
              builder: (context, state) {
                if (state is DisplayLocationLoaded) {
                  final location = state.location;

                  return Row(
                    children: [
                      _trackingDetail(location),
                      SizedBox(width: 16.w),
                      _trackingActions(context),
                    ],
                  );
                }

                if (state is DisplayLocationLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _trackingActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final service = FlutterBackgroundService();
            final isRunning = await service.isRunning();

            if (!isRunning) {
              await service.startService();
            }

            if (context.mounted) {
              _showDialogStartTracking(context);
            }
          },
          icon: const Icon(LucideIcons.play),
        ),
      ],
    );
  }

  Widget _trackingDetail(Location? location) {
    return Expanded(
      child: Column(
        children: [
          Text("Peminjaman ${widget.rent.carName}"),
        ],
      ),
    );
  }
}
