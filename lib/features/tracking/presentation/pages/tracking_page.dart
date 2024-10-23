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
import 'package:rent_n_trace/features/tracking/domain/entity/fuel_variant.dart';
import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/create_initial_locattion.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/stop_active_location.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_active_location_cubit.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_active_location_state.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_all_fuel_variants_cubit.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/display_all_fuel_variants_state.dart';
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
  FuelVariant? selectedFuelVariant;
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
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    mainContext = context;

    checkPemission();
    getInitialLocation();
    initializeMapData();
    updateMapLocation();
  }

  @override
  void dispose() {
    _mounted = false;
    mapboxMap = null;
    locationStream?.cancel();
    super.dispose();
  }

  Future<void> initializeMapData() async {
    final locationRecord = sl<Realm>().all<LocationTrackingRecord>();
    final initialRecord = locationRecord.firstOrNull;

    if (initialRecord != null) {
      if (_mounted) {
        setState(() {
          distance = initialRecord.distance;
        });
      }

      if (initialRecord.locations.isNotEmpty) {
        _updatePolyline(initialRecord.locations.toList());
        await _ensureMapReadyThenFly(initialRecord.locations.last);
      }
    }
  }

  Future<void> _ensureMapReadyThenFly(LatLng location) async {
    if (!_isMapReady) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !_isMapReady;
      });
    }
    _flyToLocation(location);
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));

    await mapboxMap.annotations.createPolylineAnnotationManager().then((value) {
      polylineAnnotationManager = value;
    });

    setState(() {
      _isMapReady = true;
    });

    initializeMapData(); // Re-initialize map data after map is created
    if (currLocation != null) {
      _flyToCurrentLocation();
    }
  }

  Future<void> getInitialLocation() async {
    final location = await gl.Geolocator.getCurrentPosition(locationSettings: locationSettings);

    if (_mounted) {
      setState(() {
        currLocation = location;
      });
    }

    await _ensureMapReadyThenFly(LatLng(location.latitude, location.longitude));
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

  void updateMapLocation() {
    final locationRecord = sl<Realm>().all<LocationTrackingRecord>();

    if (!isTracking && locationRecord.firstOrNull == null) return;

    locationStream = locationRecord.changes.listen((changes) {
      if (!_mounted) return;
      if (changes.modified.isEmpty) return;

      final newLocationRecord = locationRecord[changes.modified.first];
      if (newLocationRecord.locations.isEmpty) return;

      _updatePolyline(newLocationRecord.locations.toList());
      _flyToLocation(newLocationRecord.locations.last);

      if (_mounted) {
        setState(() {
          distance = newLocationRecord.distance;
        });
      }
    });
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

  void _showDialogChooseFuelVariant(BuildContext context) {
    FuelVariant? tempSelectedVariant = selectedFuelVariant;
    String searchQuery = '';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        alignment: Alignment.center,
        child: StatefulBuilder(builder: (context, setState) {
          return PopScope(
            onPopInvoked: (didPop) {
              selectedFuelVariant = null;
            },
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          "Pilih jenis bahan bakar kendaraan Anda",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.foreground,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Jika beragam, pilih jenis bahan bakar yang paling banyak digunakan.",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.secondForeground),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari jenis bahan bakar...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.foreground,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Flexible(
                    child: BlocProvider(
                      create: (context) => DisplayAllFuelVariantsCubit()..displayAllFuelVariants(),
                      child: BlocBuilder<DisplayAllFuelVariantsCubit, DisplayAllFuelVariantsState>(
                        builder: (context, state) {
                          if (state is DisplayAllFuelVariantsLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (state is DisplayAllFuelVariantsLoaded) {
                            final fuelVariants = state.fuelVariants
                                .where(
                                    (variant) => variant.name.toLowerCase().contains(searchQuery))
                                .toList();

                            return Scrollbar(
                              thumbVisibility: true,
                              thickness: 6.0,
                              radius: const Radius.circular(10),
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16.r),
                                shrinkWrap: true,
                                itemCount: fuelVariants.length,
                                itemBuilder: (context, index) {
                                  final isSelected = tempSelectedVariant == fuelVariants[index];
                                  return Material(
                                    color: Colors.transparent,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                      selected: isSelected,
                                      selectedTileColor: AppColors.primary.withOpacity(0.1),
                                      title: Row(
                                        children: [
                                          if (isSelected)
                                            const Icon(LucideIcons.check,
                                                color: AppColors.foreground)
                                          else
                                            SizedBox(width: 24.w),
                                          SizedBox(width: 8.w),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fuelVariants[index].name,
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                              Text(
                                                "${formatToRupiah(fuelVariants[index].price)} / liter",
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          tempSelectedVariant = fuelVariants[index];
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: BlocProvider(
                      create: (context) => ButtonStateCubit(),
                      child: BlocListener<ButtonStateCubit, ButtonState>(
                        listener: (context, state) async {
                          if (state is ButtonFailure) {
                            AppSnackbar.show(context, state.message, AppSnackbarType.error);
                          }

                          if (state is ButtonSuccess) {
                            selectedFuelVariant = tempSelectedVariant;

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
                            title: "Selesai",
                            height: 40.h,
                            onPressed: tempSelectedVariant != null
                                ? () async {
                                    double kmPerL =
                                        getDoubleValueOfKmPerL(widget.rent.carFuelConsumption!);
                                    double kmDistance = distance / 1000;
                                    double fuelCost =
                                        getFuelCost(kmDistance, kmPerL, tempSelectedVariant!.price);

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
                                  }
                                : null,
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
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
              BasicAppButton(
                title: "Yakin",
                height: 40.h,
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDialogChooseFuelVariant(context);
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
                  BasicAppButton(
                    content: Row(
                      children: [
                        Stack(children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              margin: EdgeInsets.all(2.r),
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            LucideIcons.square,
                            color: Colors.white,
                          ),
                        ]),
                        SizedBox(width: 8.w),
                        Text("Selesai",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.white)),
                      ],
                    ),
                    onPressed: () {
                      _showDialogStopTracking(context);
                    },
                    width: 100.w,
                    height: 40.h,
                  )
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
                    const timeout = Duration(seconds: 8);
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
