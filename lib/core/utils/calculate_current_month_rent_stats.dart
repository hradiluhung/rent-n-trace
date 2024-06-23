import 'package:intl/intl.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';

String calculateEstimatedFuelCost(List<Rent> rents) {
  int totalFuelCost = 0;

  for (var rent in rents) {
    if (rent.fuelConsumption != null) {
      int fuelCost = rent.fuelConsumption!;
      totalFuelCost += fuelCost;
    }
  }

  return 'Rp ${totalFuelCost == 0 ? '-' : NumberFormat('#,##0').format(totalFuelCost)}';
}

String getMostRentedCar(List<Rent> rents) {
  if (rents.isEmpty) {
    return '-';
  }

  Map<String, int> carCount = {};

  for (var rent in rents) {
    if (carCount.containsKey(rent.carName!)) {
      carCount[rent.carName!] = carCount[rent.carName!]! + 1;
    } else {
      carCount[rent.carName!] = 1;
    }
  }

  String mostRentedCar = carCount.keys.first;
  int mostRentedCarCount = carCount[mostRentedCar]!;

  for (var car in carCount.keys) {
    if (carCount[car]! > mostRentedCarCount) {
      mostRentedCar = car;
      mostRentedCarCount = carCount[car]!;
    }
  }

  return mostRentedCar;
}

String getLastRentedDate(List<Rent> rents) {
  if (rents.isEmpty) {
    return '-';
  }

  Rent lastRent = rents[0];

  for (var rent in rents) {
    if (rent.createdAt!.isAfter(lastRent.createdAt!)) {
      lastRent = rent;
    }
  }

  DateFormat dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id');
  return dateFormat.format(lastRent.createdAt!);
}
