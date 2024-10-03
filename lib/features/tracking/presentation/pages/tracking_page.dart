import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:realm/realm.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/common/models/location_creation_req.dart';
import 'package:rent_n_trace/core/common/models/stop_tracking_req.dart';
import 'package:rent_n_trace/core/common/realm/models/lat_lang.dart';
import 'package:rent_n_trace/core/common/realm/models/location_tracking_record.dart';
import 'package:rent_n_trace/core/common/widgets/app_snackbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/config/location/location_config.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/core/config/ui/ui_config.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_rent_stats_cubit.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_cubit.dart';
import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/create_initial_locattion.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/stop_active_location.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_active_location_cubit.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_active_location_state.dart';
import 'package:rent_n_trace/features/tracking/presentation/pages/tracking_result_page.dart';

class TrackingPage extends StatefulWidget {
  final Rent rent;

  const TrackingPage({super.key, required this.rent});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  MapboxMap? mapboxMap;
  gl.Position? currLocation;
  double distance = 0;
  PolylineAnnotationManager? polylineAnnotationManager;
  PolylineAnnotation? polylineAnnotation;
  StreamSubscription<RealmResultsChanges<LocationTrackingRecord>>? locationStream;
  bool isTracking = false;
  bool isPaused = false;
  bool isLoadingInitialBgService = false;
  String? locationId;
  late BuildContext mainContext;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    mainContext = context;

    checkPemission();
    getInitialLocation();
    updateMapLocation();
  }

  @override
  void dispose() {
    _mounted = false;
    mapboxMap = null;
    locationStream?.cancel();
    super.dispose();
  }

  Future<void> checkPemission() async {
    bool locationDenied = await Permission.location.isDenied;
    if (locationDenied) {
      await Permission.location.request();
    }

    bool locationAlwaysDenied = await Permission.locationAlways.isPermanentlyDenied;
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

    mapboxMap.annotations.createPolylineAnnotationManager().then((value) {
      polylineAnnotationManager = value;
    });

    if (currLocation != null) {
      _flyToCurrentLocation();
    }
  }

  void updateMapLocation() {
    final locationRecord = sl<Realm>().all<LocationTrackingRecord>();

    if (locationRecord.firstOrNull == null) return;

    locationStream = locationRecord.changes.listen((changes) {
      if (!_mounted) return;
      if (changes.modified.isEmpty) return;

      final newLocationRecord = locationRecord[changes.modified.first];
      if (newLocationRecord.locations.isEmpty) return;

      // Ubah parameter menjadi RealmList<LatLng>
      _updatePolyline(newLocationRecord.locations.toList());
      _flyToLocation(newLocationRecord.locations.last);

      if (_mounted) {
        setState(() {
          distance = newLocationRecord.distance;
        });
      }
    });
  }

  Future<void> getInitialLocation() async {
    final location = await gl.Geolocator.getCurrentPosition(locationSettings: locationSettings);

    if (_mounted) {
      setState(() {
        currLocation = location;
      });
    }

    if (mapboxMap != null) {
      _flyToCurrentLocation();
    }
  }

  void _updatePolyline(List<LatLng> locations) {
    final coordinates = locations.map((e) => Position(e.longitude, e.latitude)).toList();
    polylineAnnotationManager
        ?.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: coordinates),
            lineColor: AppColors.primary.value,
            lineWidth: 4,
          ),
        )
        .then((value) => polylineAnnotation = value);
  }

  void _flyToLocation(LatLng location) {
    if (mapboxMap == null) return;
    mapboxMap!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(location.longitude, location.latitude)),
        zoom: 14.0,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
  }

  void _flyToCurrentLocation() {
    if (currLocation == null) return;
    _flyToLocation(LatLng(currLocation!.latitude, currLocation!.longitude));
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.foreground,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
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
              BlocProvider(
                create: (context) => ButtonStateCubit(),
                child: BlocListener<ButtonStateCubit, ButtonState>(
                  listener: (context, state) {
                    if (state is ButtonFailure) {
                      AppSnackbar.show(context, state.message, AppSnackbarType.error);
                    }

                    if (state is ButtonSuccess) {
                      final location = state.data as Location;

                      final service = FlutterBackgroundService();
                      service.invoke(
                        'start-tracking',
                        {
                          'rentId': widget.rent.id,
                          'locationId': location.id,
                        },
                      );

                      if (_mounted) {
                        setState(() {
                          isTracking = true;
                          locationId = location.id;
                        });
                      }

                      mainContext
                          .read<DisplayDetailRentCubit>()
                          .updateRentStatus(RentStatus.tracked);

                      mainContext
                          .read<DislayRentStatsCubit>()
                          .updateLatestRentStatus(RentStatus.tracked);

                      updateMapLocation();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Builder(builder: (context) {
                    return BasicReactiveButton(
                      title: "Mulai",
                      height: 40.h,
                      onPressed: () {
                        if (currLocation != null) {
                          context.read<ButtonStateCubit>().execute(
                                usecase: CreateInitialLocation(),
                                params: LocationCreationReq(
                                  rentId: widget.rent.id,
                                  lat: currLocation!.latitude,
                                  long: currLocation!.longitude,
                                ),
                              );
                        }
                      },
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialogStopTracking(BuildContext context) {
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
                "Apakah Anda yakin peminjaman Anda telah selesai?",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.foreground,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                "Pastikan Anda telah sampai di tujuan dan menyerahkan kendaraan.",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.secondForeground, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              BasicAppButton(
                variant: ButtonVariant.outline,
                title: "Tidak",
                height: 40.h,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 8.h),
              BlocProvider(
                create: (context) => ButtonStateCubit(),
                child: BlocListener<ButtonStateCubit, ButtonState>(
                  listener: (context, state) async {
                    if (state is ButtonFailure) {
                      AppSnackbar.show(context, state.message, AppSnackbarType.error);
                    }

                    if (state is ButtonSuccess) {
                      final rentHistory = state.data as RentHistory;

                      final service = FlutterBackgroundService();
                      service.invoke('finish-tracking');

                      AppNavigator.pushAndRemoveUntil(
                        context,
                        TrackingResultPage(
                          rentHistory: rentHistory,
                        ),
                        (route) => route.isFirst,
                      );
                    }
                  },
                  child: Builder(builder: (context) {
                    return BasicReactiveButton(
                      title: "Yakin",
                      height: 40.h,
                      onPressed: () {
                        double kmPerL = getDoubleValueOfKmPerL(widget.rent.carFuelConsumption!);
                        double kmDistance = distance / 1000;
                        // TODO: Ganti harga bensin dengan harga bensin yang sesuai
                        double fuelCost = getFuelCost(kmDistance, kmPerL, 12950);

                        context.read<ButtonStateCubit>().execute(
                              usecase: StopActiveLocation(),
                              params: StopTrackingReq(
                                locationId: locationId,
                                rentId: widget.rent.id,
                                distance: distance,
                                fuelCost: fuelCost,
                                latlongs: sl<Realm>()
                                    .all<LocationTrackingRecord>()
                                    .first
                                    .locations
                                    .map((e) => "${e.latitude},${e.longitude}")
                                    .toList(),
                              ),
                            );
                      },
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track Peminjaman",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 20.sp,
                color: AppColors.foreground,
              ),
        ),
      ),
      body: Stack(
        children: [
          _map(),
          _controller(),
        ],
      ),
    );
  }

  Widget _map() {
    return MapWidget(
      key: const ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
    );
  }

  Widget _controller() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Container(
          decoration: appBoxDecoration,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: BlocProvider(
            create: (context) => DisplayActiveLocationCubit()..displayLocation(widget.rent.id),
            child: BlocListener<DisplayActiveLocationCubit, DisplayActiveLocationState>(
              listener: (context, state) {
                if (state is DisplayLocationLoaded) {
                  if (state.location == null) {
                    setState(() {
                      isTracking = false;
                    });
                  } else {
                    setState(() {
                      isTracking = true;
                      locationId = state.location!.id;
                    });
                  }
                }
              },
              child: BlocBuilder<DisplayActiveLocationCubit, DisplayActiveLocationState>(
                builder: (context, state) {
                  if (state is DisplayLocationLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _trackingDetail(context),
                        SizedBox(height: 24.h),
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
      ),
    );
  }

  Widget _trackingActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jarak",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              formatMtoKm(distance),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.secondForeground),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isTracking) ...[
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final service = FlutterBackgroundService();
                      if (isPaused) {
                        service.invoke('resume-tracking');
                      } else {
                        service.invoke('pause-tracking');
                      }

                      setState(() {
                        isPaused = !isPaused;
                      });
                    },
                    icon: Icon(
                      isPaused ? LucideIcons.play : LucideIcons.pause,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: () {
                      _showDialogStopTracking(context);
                    },
                    icon: const Icon(LucideIcons.square),
                  ),
                ],
              ),
            ],
            if (!isTracking) ...[
              BasicAppButton(
                onPressed: () async {
                  setState(() {
                    isLoadingInitialBgService = true;
                  });

                  final service = FlutterBackgroundService();
                  var isRunning = await service.isRunning();

                  if (!isRunning) {
                    await service.startService();

                    // Coba cek setiap 500ms hingga maksimal 5 detik
                    const timeout = Duration(seconds: 5);
                    const interval = Duration(milliseconds: 500);
                    final stopwatch = Stopwatch()..start();

                    while (!isRunning && stopwatch.elapsed < timeout) {
                      await Future.delayed(interval);
                      isRunning = await service.isRunning();
                    }

                    stopwatch.stop();
                  }

                  // Make sure dependencies are initialized
                  await Future.delayed(const Duration(seconds: 2));

                  if (context.mounted && isRunning) {
                    _showDialogStartTracking(context);
                  }

                  setState(() {
                    isLoadingInitialBgService = false;
                  });
                },
                width: 100.w,
                height: 35.h,
                content: Row(
                  children: [
                    if (isLoadingInitialBgService) ...[
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 4.w),
                    ] else ...[
                      const Icon(
                        LucideIcons.play,
                        color: Colors.white,
                      ),
                    ],
                    SizedBox(width: 8.w),
                    Text("Mulai",
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  ],
                ),
                disabled: isLoadingInitialBgService,
              ),
            ]
          ],
        ),
      ],
    );
  }

  Widget _trackingDetail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Peminjaman Anda", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8.h),
        Text("${widget.rent.carName}",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.secondForeground)),
        Text(
            "${widget.rent.startDate.toddMMMMyyyyShort()} - ${widget.rent.endDate.toddMMMMyyyyShort()}",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.secondForeground)),
      ],
    );
  }
}
