import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';

sealed class DisplayAllRentHistoriesState {}

class DisplayRentHistoriesLoading extends DisplayAllRentHistoriesState {}

class DisplayRentHistoriesLoaded extends DisplayAllRentHistoriesState {
  final List<RentHistory> rentHistories;
  DisplayRentHistoriesLoaded(this.rentHistories);
}

class DisplayRentHistoriesFailed extends DisplayAllRentHistoriesState {
  final String message;
  DisplayRentHistoriesFailed(this.message);
}
