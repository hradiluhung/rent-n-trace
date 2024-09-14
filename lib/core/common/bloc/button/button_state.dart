sealed class ButtonState {}

final class ButtonInitial extends ButtonState {}

final class ButtonLoading extends ButtonState {}

final class ButtonSuccess extends ButtonState {
  final dynamic data;
  ButtonSuccess({this.data});
}

final class ButtonFailure extends ButtonState {
  final String message;

  ButtonFailure({required this.message});
}
