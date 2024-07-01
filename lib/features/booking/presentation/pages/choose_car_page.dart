import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:rent_n_trace/core/constants/choose_car_tabs.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/show_toast.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/car/car_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/booking_summary_page.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/cards/selectable_car_card.dart';

class ChooseCarPage extends StatefulWidget {
  static route(Rent rent) =>
      MaterialPageRoute(builder: (context) => ChooseCarPage(rent: rent));

  final Rent rent;
  const ChooseCarPage({super.key, required this.rent});

  @override
  State<ChooseCarPage> createState() => _ChooseCarPageState();
}

class _ChooseCarPageState extends State<ChooseCarPage> {
  Car? selectedCar;

  @override
  void initState() {
    context.read<CarBloc>().add(CarGetAllAvailabilityCars(
          startDatetime: widget.rent.startDateTime,
          endDatetime: widget.rent.endDateTime,
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                'Detail Booking (2/2)',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 16.sp,
                    ),
              ),
              Text("Pilih Kendaraan",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14.sp)),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(EvaIcons.infoOutline),
          ),
        ],
      ),
      body: Stack(children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 16.r, left: 16.w, right: 16.w),
              child: ChooseCarContent(
                selectedCar: selectedCar,
                onSelectCar: (car) {
                  setState(() {
                    selectedCar = car;
                  });
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 72.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppPalette.transparentColor,
                  AppPalette.halfTransparentColor,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: PrimaryButton(
              onPressed: () {
                if (selectedCar == null) {
                  showToast(
                    context: context,
                    message: "Pilih kendaraan terlebih dahulu",
                    icon: EvaIcons.alertCircleOutline,
                    status: WidgetStatus.error,
                  );
                  return;
                }
                Navigator.push(
                  context,
                  BookingSummaryPage.route(
                    Rent(
                      id: widget.rent.id,
                      userId: widget.rent.userId,
                      startDateTime: widget.rent.startDateTime,
                      endDateTime: widget.rent.endDateTime,
                      destination: widget.rent.destination,
                      need: widget.rent.need,
                      needDetail: widget.rent.needDetail,
                      driverId: widget.rent.driverId,
                      driverName: widget.rent.driverName,
                      carId: selectedCar!.id,
                      carName: selectedCar!.name,
                      carImage: selectedCar!.images[0],
                    ),
                  ),
                );
              },
              text: "Tinjau Booking",
              isFullWidth: true,
            ),
          ),
        ),
      ]),
    );
  }
}

class ChooseCarContent extends StatefulWidget {
  final Car? selectedCar;
  final void Function(Car car) onSelectCar;
  const ChooseCarContent({
    super.key,
    this.selectedCar,
    required this.onSelectCar,
  });

  @override
  State<ChooseCarContent> createState() => _ChooseCarContentState();
}

class _ChooseCarContentState extends State<ChooseCarContent> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          selectedTabIndex: selectedTabIndex,
          onSelectedTab: (index) {
            setState(() {
              selectedTabIndex = index;
            });
          },
        ),
        SizedBox(height: 16.h),
        CarList(
          selectedTabIndex: selectedTabIndex,
          selectedCar: widget.selectedCar,
          onSelectCar: widget.onSelectCar,
        ),
        SizedBox(height: 64.h),
      ],
    );
  }
}

class TabBar extends StatelessWidget {
  final int selectedTabIndex;
  final void Function(int index) onSelectedTab;

  const TabBar({
    super.key,
    required this.selectedTabIndex,
    required this.onSelectedTab,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: chooseCarTabList
          .mapWithIndex(
            (e, index) => Padding(
              padding: EdgeInsets.only(
                  right: index == chooseCarTabList.length - 1 ? 0 : 8.w),
              child: InkWell(
                onTap: () {
                  onSelectedTab(
                    chooseCarTabList.indexOf(e),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: selectedTabIndex == chooseCarTabList.indexOf(e)
                        ? AppPalette.activeTabColor
                        : AppPalette.greyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    child: Text(
                      e.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color:
                                selectedTabIndex == chooseCarTabList.indexOf(e)
                                    ? AppPalette.whiteColor
                                    : AppPalette.bodyTextColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class CarList extends StatefulWidget {
  final int selectedTabIndex;
  final Car? selectedCar;
  final void Function(Car car) onSelectCar;

  const CarList({
    super.key,
    required this.selectedTabIndex,
    required this.selectedCar,
    required this.onSelectCar,
  });

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarBloc, CarState>(listener: (context, state) {
      if (state is CarFailure) {
        showToast(context: context, message: state.message);
      }
    }, builder: (context, state) {
      if (state is CarLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is CarAllAvailabilityCarsLoaded) {
        final availableCars = state.availableCars;
        final notAvailableCars = state.notAvailableCars;

        switch (widget.selectedTabIndex) {
          case 0:
            if (availableCars.isNotEmpty) {
              return CarListContent(
                availableCars: availableCars,
                notAvailableCars: notAvailableCars,
                selectedCar: widget.selectedCar,
                onSelectCar: widget.onSelectCar,
              );
            } else {
              return Text(
                "Tidak ada mobil",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                    ),
              );
            }
          case 1:
            return CarListContent(
              availableCars: availableCars,
              selectedCar: widget.selectedCar,
              onSelectCar: widget.onSelectCar,
            );
          case 2:
            if (notAvailableCars.isNotEmpty) {
              return CarListContent(
                notAvailableCars: notAvailableCars,
                selectedCar: widget.selectedCar,
                onSelectCar: widget.onSelectCar,
              );
            } else {
              return Text(
                "Tidak ada mobil",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                    ),
              );
            }
          default:
            return const SizedBox.shrink();
        }
      }

      return const SizedBox.shrink();
    });
  }
}

class CarListContent extends StatelessWidget {
  final List<Car>? availableCars;
  final List<Car>? notAvailableCars;
  final Car? selectedCar;
  final void Function(Car car) onSelectCar;

  const CarListContent({
    super.key,
    this.availableCars,
    this.notAvailableCars,
    required this.selectedCar,
    required this.onSelectCar,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      children: [
        if (availableCars != null)
          for (final car in availableCars!)
            SelectableCarCard(
              car: car,
              isSelected: selectedCar == car,
              isDisabled: false,
              onClick: onSelectCar,
            ),
        if (notAvailableCars != null)
          for (final car in notAvailableCars!)
            SelectableCarCard(
              car: car,
              isSelected: selectedCar == car,
              isDisabled: true,
            ),
      ],
    );
  }
}
