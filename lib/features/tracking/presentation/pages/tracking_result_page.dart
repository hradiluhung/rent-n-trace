import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/config/assets/app_images.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/home/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/tracking/presentation/pages/tracking_update_fuel_cost_page.dart';

class TrackingResultPage extends StatefulWidget {
  final RentHistory rentHistory;
  const TrackingResultPage({super.key, required this.rentHistory});

  @override
  State<TrackingResultPage> createState() => _TrackingResultPageState();
}

class _TrackingResultPageState extends State<TrackingResultPage>
    with SingleTickerProviderStateMixin {
  MapboxMap? mapboxMap;

  late AnimationController _animationController;
  late Animation<double> _fadeInUpAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInUpAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flyToFitCoordinates(List<Position> coordinates) async {
    if (mapboxMap == null || coordinates.isEmpty) return;

    List<Point> points = coordinates.map((coord) => Point(coordinates: coord)).toList();

    CameraOptions cameraOptions = await mapboxMap!.cameraForCoordinatesPadding(
      points,
      CameraOptions(),
      MbxEdgeInsets(top: 24.r, right: 24.r, bottom: 24.r, left: 24.r),
      1000,
      null,
    );

    mapboxMap!.flyTo(
      cameraOptions,
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    final coordinates = widget.rentHistory.latlongs.map((e) {
      final latlong = e.split(',');
      return Position(double.parse(latlong[1]), double.parse(latlong[0]));
    }).toList();

    await mapboxMap.annotations.createPolylineAnnotationManager().then((value) async {
      PolylineAnnotationManager polylineAnnotationManager = value;
      await polylineAnnotationManager.create(PolylineAnnotationOptions(
        geometry: LineString(coordinates: coordinates),
        lineColor: AppColors.primary.value,
        lineWidth: 4,
      ));
    });

    await mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      PointAnnotationManager pointAnnotationManager = value;
      final ByteData bytes = await rootBundle.load(AppImages.marker);
      final Uint8List list = bytes.buffer.asUint8List();

      var options = <PointAnnotationOptions>[];

      Point firstPoint = Point(coordinates: coordinates.first);
      options.add(PointAnnotationOptions(
          geometry: firstPoint, image: list, iconSize: 0.6, iconAnchor: IconAnchor.BOTTOM));

      Point lastPoint = Point(coordinates: coordinates.last);
      options.add(PointAnnotationOptions(
          geometry: lastPoint, image: list, iconSize: 0.6, iconAnchor: IconAnchor.BOTTOM));

      pointAnnotationManager.createMulti(options);
    });

    _flyToFitCoordinates(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: FadeTransition(
            opacity: _animationController,
            child: Transform.translate(
              offset: Offset(0, _fadeInUpAnimation.value),
              child: Column(
                children: [
                  Text(
                    'Hasil Peminjaman',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.foreground,
                        ),
                  ),
                  SizedBox(height: 36.h),
                  _map(),
                  SizedBox(height: 24.h),
                  _rentResultInfo(context),
                  SizedBox(height: 24.h),
                  _rentHistoryFeedback(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rentHistoryFeedback(BuildContext context) {
    return Column(
      children: [
        Text(
          "Apakah estimasi biaya bensin sudah sesuai?",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 16.h),
        BasicAppButton(
          onPressed: () {
            AppNavigator.push(context, TrackingUpdateFuelCostPage(rentHistory: widget.rentHistory));
          },
          variant: ButtonVariant.outline,
          title: "Tidak, belum sesuai",
        ),
        SizedBox(height: 8.h),
        BasicAppButton(
          onPressed: () {
            AppNavigator.pushAndRemove(context, const LandingPage());
          },
          title: "Ya, sesuai",
        ),
      ],
    );
  }

  Widget _map() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 200.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r), // Ensure the same border radius
          child: MapWidget(
            key: const ValueKey("mapWidget"),
            onMapCreated: _onMapCreated,
          ),
        ),
      ),
    );
  }

  Widget _rentResultInfo(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Jarak Tempuh",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${(widget.rentHistory.distance / 1000).toStringAsFixed(2)} km',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.secondForeground),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Estimasi biaya bensin",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    formatToRupiah(widget.rentHistory.fuelCost),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.secondForeground),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
