import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';
import 'package:rent_n_trace/core/common/widgets/app_alert.dart';
import 'package:rent_n_trace/core/common/widgets/app_snackbar.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/config/assets/app_images.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_status_card.dart';
import 'package:rent_n_trace/features/home/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/rent/create_rent.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_available_cars_cubit.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_available_cars_state.dart';

class RentChooseCarPage extends StatefulWidget {
  final RentCreationReq rent;
  const RentChooseCarPage({super.key, required this.rent});

  @override
  State<RentChooseCarPage> createState() => _RentChooseCarPageState();
}

class _RentChooseCarPageState extends State<RentChooseCarPage> {
  Car? selectedCar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Pilih Mobil",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 20.sp,
                color: AppColors.foreground,
              ),
        ),
      ),
      bottomNavigationBar: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailure) {
                AppSnackbar.show(context, state.message, AppSnackbarType.error);
              }

              if (state is ButtonSuccess) {
                final message = state.data as String;

                AppSnackbar.show(context, message, AppSnackbarType.success);
                AppNavigator.pushAndRemove(context, const LandingPage());
              }
            },
            child: Builder(builder: (context) {
              return BasicReactiveButton(
                onPressed: selectedCar != null
                    ? () {
                        widget.rent.carId = selectedCar!.id;
                        context.read<ButtonStateCubit>().execute(
                            usecase: CreateRent(), params: widget.rent);
                      }
                    : null,
                title: "Ajukan Sewa",
              );
            }),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => DisplayAvailableCarsCubit()
          ..displayCars(DateRangeReq(
              startDate: widget.rent.startDate!,
              endDate: widget.rent.endDate!)),
        child:
            BlocBuilder<DisplayAvailableCarsCubit, DisplayAvailableCarsState>(
          builder: (context, state) {
            if (state is DisplayCarsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DisplayCarsLoaded) {
              final isNotEmpty = state.cars.isNotEmpty;

              if (isNotEmpty) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      AppAlert(
                          icon: LucideIcons.info,
                          message:
                              "Hanya menampilkan mobil yang tersedia sesuai tanggal peminjaman",
                          variant: AppAlertVariant.info),
                      SizedBox(height: 24.h),
                      _carList(context, state.cars),
                    ],
                  ),
                );
              }

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.emptyData,
                        height: 100.h,
                      ),
                      SizedBox(height: 16.h),
                      const Text(
                        "Tidak ada mobil tersedia. Coba pilih tanggal lain atau hubungi admin",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            } else if (state is DisplayCarsFailed) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _carList(BuildContext context, List<Car> cars) {
    return GridView.builder(
      itemCount: cars.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1 / 1.2,
      ),
      itemBuilder: (context, index) {
        return CarStatusCard(
          car: cars[index],
          selectable: true,
          onSelect: (car) {
            setState(() {
              selectedCar = car;
            });
          },
          selected: selectedCar?.id == cars[index].id,
        );
      },
    );
  }
}
