import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';

sealed class DisplayDetailRentHistoryState {}

class DisplayDetailRentHistoryLoading extends DisplayDetailRentHistoryState {}

class DisplayDetailRentHistoryLoaded extends DisplayDetailRentHistoryState {
  final RentHistory rentHistory;
  DisplayDetailRentHistoryLoaded(this.rentHistory);
}

class DisplayDetailRentHistoryFailed extends DisplayDetailRentHistoryState {
  final String message;
  DisplayDetailRentHistoryFailed(this.message);
}
