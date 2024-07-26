String formatDistance(double distanceInMeters) {
  if (distanceInMeters < 1000) {
    return "${distanceInMeters.toStringAsFixed(0)} m";
  } else {
    double distanceInKm = distanceInMeters / 1000;
    return "${distanceInKm.toStringAsFixed(2)} km";
  }
}

double meterToKm(double distanceInMeters) {
  return distanceInMeters / 1000;
}
