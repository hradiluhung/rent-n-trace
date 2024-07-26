import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:realm/realm.dart';
import 'package:rent_n_trace/core/common/realm/realm_config.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/confirmation_dialog.dart';
import 'package:rent_n_trace/core/utils/distance_calculator.dart';
import 'package:rent_n_trace/core/utils/toast.dart';
import 'package:rent_n_trace/features/tracking/data/models/realm/local_locations.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/location/location_bloc.dart';
import 'package:rent_n_trace/features/tracking/presentation/pages/tracking_result_page.dart';

class TrackingPage extends StatefulWidget {
  static route(String rentId) => MaterialPageRoute(builder: (context) => TrackingPage(rentId: rentId));

  final String rentId;
  const TrackingPage({super.key, required this.rentId});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  Realm realm = RealmConfig().getRealm();

  MapboxMap? mapboxMap;
  PolylineAnnotationManager? polylineAnnotationManager;
  PolylineAnnotation? polylineAnnotation;
  StreamSubscription<RealmResultsChanges<LocalLocations>>? locationDataSubscription;

  bool isTracking = false;
  bool isPaused = false;
  bool isLoadingStartService = false;
  List<LatLng> coordinates = [];
  double distance = 0.0;
  DateTime? lastUpdated;

  bool hasProcessed = false;

  @override
  void initState() {
    super.initState();

    _initCoordinates();
  }

  @override
  void dispose() {
    mapboxMap = null;
    locationDataSubscription?.cancel();

    super.dispose();
  }

  _initCoordinates() async {
    final isRunning = await FlutterBackgroundService().isRunning();

    if (isRunning) {
      final locationData = realm.all<LocalLocations>();

      if (locationData.isNotEmpty) {
        final data = locationData.first;
        if (mounted) {
          setState(() {
            isTracking = true;
            coordinates = data.locations.map((e) => LatLng(e.latitude, e.longitude)).toList();
            distance = data.distance;
            lastUpdated = data.timestamp;
          });
        }
      }

      _trackLocation();
    }
  }

  _trackLocation() {
    final locationData = realm.all<LocalLocations>();
    locationDataSubscription = locationData.changes.listen((event) async {
      if (locationData.isNotEmpty) {
        final data = locationData.first;

        coordinates = data.locations.map((e) => LatLng(e.latitude, e.longitude)).toList();
        distance = data.distance;
        lastUpdated = data.timestamp;

        if (mounted) setState(() {});

        final location = await gl.Geolocator.getCurrentPosition(desiredAccuracy: gl.LocationAccuracy.high);
        mapboxMap?.flyTo(
          CameraOptions(
            center: Point(
              coordinates: Position(location.longitude, location.latitude),
            ),
            zoom: 14.0,
          ),
          MapAnimationOptions(duration: 2000, startDelay: 0),
        );

        polylineAnnotationManager
            ?.create(
              PolylineAnnotationOptions(
                geometry: LineString(
                  coordinates: data.locations.map((e) => Position(e.longitude, e.latitude)).toList(),
                ),
                lineColor: AppPalette.primaryColor2.value,
                lineWidth: 4,
              ),
            )
            .then((value) => polylineAnnotation = value);
      }
    });
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    if (!mounted) return;
    this.mapboxMap = mapboxMap;

    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));

    mapboxMap.annotations.createPolylineAnnotationManager().then((value) {
      polylineAnnotationManager = value;
    });

    final location = await gl.Geolocator.getCurrentPosition(desiredAccuracy: gl.LocationAccuracy.high);

    mapboxMap.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(location.longitude, location.latitude),
        ),
        zoom: 14.0,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
  }

  void _showStartTrackingDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        dismissText: "Tidak",
        confirmText: "Ya",
        title: "Konfirmasi",
        content: "Apakah Anda yakin ingin memulai tracking?",
        onConfirm: () async {
          Navigator.pop(context);

          final service = FlutterBackgroundService();

          setState(() {
            isLoadingStartService = true;
          });
          await service.startService();
          await Future.delayed(const Duration(seconds: 3));

          if (await service.isRunning()) {
            service.invoke('startService', {
              'rentId': widget.rentId,
            });

            _trackLocation();

            setState(() {
              isTracking = true;
              isLoadingStartService = false;
            });
          }
        },
        onDismiss: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStopTrackingDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        dismissText: "Tidak",
        confirmText: "Ya",
        title: "Konfirmasi",
        content: "Apakah Anda yakin ingin menghentikan tracking?",
        onConfirm: () {
          Navigator.pop(context);
          FlutterBackgroundService().invoke('stopService');

          locationDataSubscription?.cancel();

          setState(() {
            isTracking = false;
          });

          context.read<LocationBloc>().add(
                LocationStopTrackingEvent(
                  rentId: widget.rentId,
                  positions: coordinates,
                  distance: distance,
                ),
              );
        },
        onDismiss: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationLoading) {
            showToast(context: context, message: "Tracking disimpan");
          }

          if (state is LocationFailure) {
            showToast(context: context, message: state.message, status: WidgetStatus.error);
          }

          if (state is LocationUpdateSuccess) {
            showToast(context: context, message: state.message, status: WidgetStatus.success);
            Navigator.push(context, TrackingResultPage.route(widget.rentId));
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              MapWidget(
                key: const ValueKey("mapWidget"),
                onMapCreated: _onMapCreated,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppPalette.borderColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            EvaIcons.pinOutline,
                          ),
                          Text(
                            "Jarak: ${formatDistance(distance)}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (isTracking) ...[
                        Row(
                          children: [
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.r),
                                onTap: () {
                                  _showStopTrackingDialog();
                                },
                                child: Ink(
                                  width: 40.r,
                                  height: 40.r,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppPalette.errorColor,
                                  ),
                                  child: const Icon(
                                    Icons.stop,
                                    size: 24,
                                    color: AppPalette.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.r),
                                onTap: () {
                                  final service = FlutterBackgroundService();

                                  if (!isPaused) {
                                    service.invoke('pauseService');

                                    setState(() {
                                      isPaused = true;
                                    });
                                  } else {
                                    service.invoke('resumeService');

                                    setState(() {
                                      isPaused = false;
                                    });
                                  }
                                },
                                child: Ink(
                                  width: 40.r,
                                  height: 40.r,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppPalette.greyColor.withOpacity(0.2),
                                    border: Border.all(
                                      color: AppPalette.greyColor.withOpacity(0.4),
                                      width: 0.8.w,
                                    ),
                                  ),
                                  child: Icon(
                                    !isPaused ? Icons.pause : Icons.play_arrow,
                                    size: 24,
                                    color: AppPalette.bodyTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ] else ...[
                        PrimaryButton(
                          onPressed: () async {
                            _showStartTrackingDialog();
                          },
                          text: "Start",
                          icon: EvaIcons.navigation2Outline,
                          widgetSize: WidgetSizes.small,
                          isLoading: isLoadingStartService,
                          isDisabled: isLoadingStartService,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
