import 'package:intl/intl.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';

String? getMostFrequentCarName(List<RentHistory> rentHistories) {
  Map<String, int> carNameFrequency = {};

  for (var history in rentHistories) {
    if (history.carName != null) {
      carNameFrequency[history.carName!] = (carNameFrequency[history.carName!] ?? 0) + 1;
    }
  }

  String? mostFrequentCarName;
  int maxFrequency = 0;

  carNameFrequency.forEach((carName, frequency) {
    if (frequency > maxFrequency) {
      mostFrequentCarName = carName;
      maxFrequency = frequency;
    }
  });

  return mostFrequentCarName;
}

String formatToRupiah(double number) {
  final formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp. ',
    decimalDigits: 2,
  );

  return formatter.format(number);
}

double getDoubleValueOfKmPerL(String kmPerL) {
  String numericValue = kmPerL.replaceAll(RegExp(r'[^0-9.]'), '');

  return double.parse(numericValue);
}

double getFuelCost(double distance, double kmPerL, double fuelPrice) {
  double fuelNeeded = distance / kmPerL;
  double fuelCost = fuelNeeded * fuelPrice;

  return fuelCost;
}

Map<String, List<RentHistory>> groupRentHistoriesByTimePeriod(List<RentHistory> histories) {
  final now = DateTime.now();

  final groupedHistories = <String, List<RentHistory>>{};

  for (final history in histories) {
    final period = _getTimePeriod(now, history.createdAt);
    if (!groupedHistories.containsKey(period)) {
      groupedHistories[period] = [];
    }
    groupedHistories[period]!.add(history);
  }

  return groupedHistories;
}

String _getTimePeriod(DateTime now, DateTime createdAt) {
  final difference = now.difference(createdAt);

  if (difference.inDays < 1) {
    return 'Hari ini';
  } else if (difference.inDays < 2) {
    return 'Kemarin';
  } else if (difference.inDays < 7) {
    return 'Minggu Lalu';
  } else if (difference.inDays < 30) {
    return 'Bulan Lalu';
  } else {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
  }
}
