import 'package:rent_n_trace/features/profile/domain/entity/division.dart';

sealed class DisplayAllDivisionsState {}

class DisplayAllDivisionsLoading extends DisplayAllDivisionsState {}

class DisplayAllDivisionsLoaded extends DisplayAllDivisionsState {
  final List<Division> divisions;
  DisplayAllDivisionsLoaded(this.divisions);
}

class DisplayAllDivisionsFailed extends DisplayAllDivisionsState {
  final String message;
  DisplayAllDivisionsFailed(this.message);
}
