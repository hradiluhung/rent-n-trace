import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';

sealed class DislayRentStatsState {}

class DislayRentStatsLoading extends DislayRentStatsState {}

class DislayRentStatsLoaded extends DislayRentStatsState {
  final List<RentHistory> currentMonthRents;
  final Rent? latestRent;

  DislayRentStatsLoaded({required this.currentMonthRents, required this.latestRent});
}

class DislayRentStatsFailed extends DislayRentStatsState {
  final String message;

  DislayRentStatsFailed({required this.message});
}
