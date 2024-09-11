import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';

sealed class DisplayActiveLocationState {}

class DisplayLocationLoading extends DisplayActiveLocationState {}

class DisplayLocationLoaded extends DisplayActiveLocationState {
  final Location? location;
  DisplayLocationLoaded(this.location);
}

class DisplayLocationFailed extends DisplayActiveLocationState {
  final String message;
  DisplayLocationFailed(this.message);
}
