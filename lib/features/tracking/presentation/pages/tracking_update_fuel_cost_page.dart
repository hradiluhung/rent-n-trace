import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/common/models/fuel_cost_update_req.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_input_field.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/landing/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/update_fuel_cost.dart';

class TrackingUpdateFuelCostPage extends StatefulWidget {
  final RentHistory rentHistory;
  const TrackingUpdateFuelCostPage({super.key, required this.rentHistory});

  @override
  State<TrackingUpdateFuelCostPage> createState() => _TrackingUpdateFuelCostPageState();
}

class _TrackingUpdateFuelCostPageState extends State<TrackingUpdateFuelCostPage> {
  final TextEditingController _fuelCostCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: BlocProvider(
            create: (context) => ButtonStateCubit(),
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
                    content: Text("Biaya bensin berhasil diupdate"),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);

                  AppNavigator.pushAndRemove(context, const LandingPage());
                }
              },
              child: Column(
                children: [
                  Text(
                    "Silakan masukkan biaya bensin yang sebenarnya",
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  RichText(
                    text: TextSpan(
                      text: "Estimasi biaya bensin: ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: formatToRupiah(widget.rentHistory.fuelCost),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.foreground,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormInputField(
                          controller: _fuelCostCon,
                          hintText: "Biaya bensin dalam Rupiah (Rp)",
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          name: "Biaya bensin",
                          required: true,
                        ),
                        SizedBox(height: 16.h),
                        Builder(builder: (context) {
                          return BasicReactiveButton(
                            title: "Simpan",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ButtonStateCubit>().execute(
                                    usecase: UpdateFuelCost(),
                                    params: FuelCostUpdateReq(
                                      fuelCost: double.parse(_fuelCostCon.text),
                                      rentId: widget.rentHistory.id,
                                    ));
                              }
                            },
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
