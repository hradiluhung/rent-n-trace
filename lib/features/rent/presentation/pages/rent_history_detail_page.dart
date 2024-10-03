import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/config/assets/app_images.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_detailed_card.dart';
import 'package:rent_n_trace/features/driver/presentation/widgets/driver_card.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_history_cubit.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_history_state.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_status_badge.dart';

class RentHistoryDetailPage extends StatefulWidget {
  final String rentHistoryId;
  const RentHistoryDetailPage({super.key, required this.rentHistoryId});

  @override
  State<RentHistoryDetailPage> createState() => _RentHistoryDetailPageState();
}

class _RentHistoryDetailPageState extends State<RentHistoryDetailPage> {
  MapboxMap? mapboxMap;

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

  _onMapCreated(MapboxMap mapboxMap, RentHistory rentHistory) async {
    this.mapboxMap = mapboxMap;

    final coordinates = rentHistory.latlongs.map((e) {
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
      appBar: BasicAppbar(
        title: Text("Detail Riwayat Peminjaman",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.secondForeground,
                )),
      ),
      body: BlocProvider(
        create: (context) =>
            DisplayDetailRentHistoryCubit()..displayDetailRentHistory(widget.rentHistoryId),
        child: BlocBuilder<DisplayDetailRentHistoryCubit, DisplayDetailRentHistoryState>(
          builder: (context, state) {
            if (state is DisplayDetailRentHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DisplayDetailRentHistoryLoaded) {
              return Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: _detailRentHistory(context, state.rentHistory),
                ),
              );
            } else if (state is DisplayDetailRentHistoryFailed) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _detailRentHistory(BuildContext context, RentHistory rentHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _map(rentHistory),
        SizedBox(height: 20.h),
        CarDetailedCard(
            carImage: rentHistory.carImage!,
            carName: rentHistory.carName!,
            carFuelType: rentHistory.carFuelType!,
            carFuelConsumption: rentHistory.carFuelConsumption!),
        if (rentHistory.driverName != null) ...[
          SizedBox(height: 20.h),
          DriverCard(
            driverName: rentHistory.driverName!,
            driverPhoto: rentHistory.driverPhoto,
          )
        ],
        SizedBox(height: 20.h),
        _otherDetail(context, rentHistory),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _rentData(String label, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        value,
      ],
    );
  }

  Widget _otherDetail(BuildContext context, RentHistory rentHistory) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rentData(
            "Tanggal Peminjaman",
            Text(
              "${rentHistory.rentStartDate!.toddMMMMyyyyShort()} - ${rentHistory.rentEndDate!.toddMMMMyyyyShort()}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 20.h),
          _rentData(
            "Kebutuhan",
            Text(
              rentHistory.rentNeed!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 20.h),
          _rentData(
            "Detail Kebutuhan",
            Text(
              rentHistory.rentNeedDetail!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 20.h),
          _rentData(
            "Tujuan",
            Text(
              rentHistory.rentDestination!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  ),
            ),
          ),
          SizedBox(height: 20.h),
          _rentData(
            "Status",
            RentStatusBadge(rentStatus: rentHistory.rentStatus!),
          ),
        ],
      ),
    );
  }

  Widget _map(RentHistory rentHistory) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 200.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: MapWidget(
            key: const ValueKey("mapWidget"),
            onMapCreated: (mapboxMap) => _onMapCreated(mapboxMap, rentHistory),
          ),
        ),
      ),
    );
  }
}
