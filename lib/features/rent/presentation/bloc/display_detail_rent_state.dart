import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';

sealed class DisplayDetailRentState {}

class DisplayDetailRentLoading extends DisplayDetailRentState {}

class DisplayDetailRentLoaded extends DisplayDetailRentState {
  final Rent rent;
  DisplayDetailRentLoaded(this.rent);
}

class DisplayDetailRentFailed extends DisplayDetailRentState {
  final String message;
  DisplayDetailRentFailed(this.message);
}
