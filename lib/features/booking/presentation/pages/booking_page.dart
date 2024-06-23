import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/custom_checkbox.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_dropdown_field.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_datetime_field.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_field.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_textarea_field.dart';
import 'package:rent_n_trace/core/constants/needs.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/driver/driver_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/choose_car_page.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/tetriary_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

class BookingPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const BookingPage());
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                'Detail Booking (1/2)',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 16.sp,
                    ),
              ),
              Text("Keterangan Peminjaman",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                      )),
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
      body: const Scrollbar(
        child: SingleChildScrollView(
          child: BookingForm(),
        ),
      ),
    );
  }
}

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isNeedDriver = false;

  final _destinationTextController = TextEditingController();
  final _startEndDateTextController = TextEditingController();
  final _needDropdownController = SingleValueDropDownController();
  final _detailNeedTextController = TextEditingController();
  final _driverDropdownController = SingleValueDropDownController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<DriverBloc>().add(DriverGetAvailableDrivers());
  }

  @override
  void dispose() {
    _destinationTextController.dispose();
    _startEndDateTextController.dispose();
    super.dispose();
  }

  void _navigateToChooseCarPage() {
    if (_formKey.currentState!.validate()) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      Rent initialRent = Rent.createInitial(
        id: const Uuid().v1(),
        userId: userId,
        startDateTime: _startDate!,
        endDateTime: _endDate!,
        destination: _destinationTextController.text,
        need: _needDropdownController.dropDownValue?.value,
        needDetail: _detailNeedTextController.text,
        driverId: _isNeedDriver
            ? _driverDropdownController.dropDownValue?.value
            : null,
        driverName: _isNeedDriver
            ? _driverDropdownController.dropDownValue?.name
            : null,
      );
      Navigator.of(context).push(ChooseCarPage.route(initialRent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormRangeDateInputField(
                  controller: _startEndDateTextController,
                  hintText: "dd/mm/yyyy - dd/mm/yyyy",
                  labelText: "Waktu Peminjaman",
                  prefixIcon: EvaIcons.calendarOutline,
                  isRequired: true,
                  onDateSelected: (PickerDateRange? dateRange) {
                    if (dateRange != null) {
                      setState(() {
                        _startDate = dateRange.startDate;
                        _endDate = dateRange.endDate;
                      });
                    }
                  },
                ),
                SizedBox(height: 6.h),
                FormInputField(
                  controller: _destinationTextController,
                  hintText: "(Nama Kecamatan), (Nama Kota)",
                  labelText: "Tujuan",
                  prefixIcon: EvaIcons.pinOutline,
                  isRequired: true,
                ),
                SizedBox(height: 6.h),
                FormDropdownField(
                  controller: _needDropdownController,
                  labelText: "Keperluan",
                  hintText: "Pilih Keperluan",
                  prefixIcon: EvaIcons.fileTextOutline,
                  isRequired: true,
                  items: needList
                      .map((e) =>
                          DropDownValueModel(name: e.name, value: e.name))
                      .toList(),
                ),
                SizedBox(height: 6.h),
                FormTextareaField(
                  controller: _detailNeedTextController,
                  hintText: "Jelaskan keperluan Anda",
                  labelText: "Detail Keperluan",
                  isRequired: true,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 6.h),
                CustomCheckbox(
                  value: _isNeedDriver,
                  labelText: "Butuh Supir",
                  onChanged: (value) {
                    setState(() {
                      _isNeedDriver = value!;
                    });
                  },
                ),
                if (_isNeedDriver)
                  BlocBuilder<DriverBloc, DriverState>(
                      builder: (context, state) {
                    if (state is DriverGetDriversSuccess) {
                      return FormDropdownField(
                        controller: _driverDropdownController,
                        labelText: "Supir",
                        hintText: "Pilih Supir",
                        prefixIcon: EvaIcons.personOutline,
                        isRequired: true,
                        items: state.drivers!
                            .map((e) =>
                                DropDownValueModel(name: e.name, value: e.id))
                            .toList(),
                      );
                    }

                    return const SizedBox.shrink();
                  }),
                SizedBox(height: 16.h),
                TetriaryButton(
                  text: "Pilih Kendaraan",
                  onPressed: () {
                    _navigateToChooseCarPage();
                  },
                  icon: EvaIcons.arrowForwardOutline,
                  isFullWidth: true,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
