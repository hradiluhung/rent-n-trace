import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_card.dart';
import 'package:rent_n_trace/features/landing/presentation/pages/landing_page.dart';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Mobil"),
            Text(
              "Hanya menampilkan mobil yang tersedia",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailure) {
                var snackbar = SnackBar(
                  content: Text(state.message, style: const TextStyle(color: Colors.white)),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.error,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }

              if (state is ButtonSuccess) {
                var snackbar = const SnackBar(
                  content: Text("Berhasil mengajukan peminjaman"),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                AppNavigator.pushAndRemove(context, const LandingPage());
              }
            },
            child: Builder(builder: (context) {
              return BasicReactiveButton(
                onPressed: selectedCar != null
                    ? () {
                        widget.rent.carId = selectedCar!.id;
                        context
                            .read<ButtonStateCubit>()
                            .execute(usecase: CreateRent(), params: widget.rent);
                      }
                    : null,
                title: "Ajukan Sewa",
              );
            }),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: BlocProvider(
          create: (context) => DisplayAvailableCarsCubit()
            ..displayCars(
                DateRangeReq(startDate: widget.rent.startDate!, endDate: widget.rent.endDate!)),
          child: BlocBuilder<DisplayAvailableCarsCubit, DisplayAvailableCarsState>(
            builder: (context, state) {
              if (state is DisplayCarsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DisplayCarsLoaded) {
                return _carList(context, state.cars);
              } else if (state is DisplayCarsFailed) {
                return Center(child: Text(state.message));
              }

              return const SizedBox.shrink();
            },
          ),
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
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return CarCard(
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
