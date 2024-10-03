import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/common/models/fuel_cost_update_req.dart';
import 'package:rent_n_trace/core/common/widgets/app_snackbar.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_input_field.dart';
import 'package:rent_n_trace/features/home/presentation/pages/landing_page.dart';
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
      appBar: const BasicAppbar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
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
            child: Column(
              children: [
                Text(
                  "Silakan masukkan biaya bensin yang sebenarnya",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 36.h),
                RichText(
                  text: TextSpan(
                    text: "Estimasi biaya bensin: ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: formatToRupiah(widget.rentHistory.fuelCost),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
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
                      SizedBox(height: 20.h),
                      Builder(builder: (context) {
                        return BasicReactiveButton(
                          title: "Simpan",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ButtonStateCubit>().execute(
                                  usecase: UpdateFuelCost(),
                                  params: FuelCostUpdateReq(
                                    fuelCost: double.parse(_fuelCostCon.text),
                                    rentId: widget.rentHistory.rentId,
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
    );
  }
}
