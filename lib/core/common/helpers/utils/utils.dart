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
    symbol: 'Rp ',
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

  groupedHistories.forEach((key, value) {
    value.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  });

  final orderedGroupedHistories = <String, List<RentHistory>>{};

  if (groupedHistories.containsKey('Hari ini')) {
    orderedGroupedHistories['Hari ini'] = groupedHistories['Hari ini']!;
  }

  if (groupedHistories.containsKey('Bulan Ini')) {
    orderedGroupedHistories['Bulan Ini'] = groupedHistories['Bulan Ini']!;
  }

  if (groupedHistories.containsKey('Bulan Lalu')) {
    orderedGroupedHistories['Bulan Lalu'] = groupedHistories['Bulan Lalu']!;
  }

  final monthKeys = groupedHistories.keys
      .where((key) => !['Hari ini', 'Bulan Ini', 'Bulan Lalu'].contains(key))
      .toList();

  monthKeys.sort((a, b) {
    final aDate = _parseMonthYear(a);
    final bDate = _parseMonthYear(b);
    return bDate.compareTo(aDate);
  });

  for (final key in monthKeys) {
    orderedGroupedHistories[key] = groupedHistories[key]!;
  }

  return orderedGroupedHistories;
}

String _getTimePeriod(DateTime now, DateTime createdAt) {
  final difference = now.difference(createdAt);

  if (difference.inDays < 1) {
    return 'Hari ini';
  } else if (createdAt.year == now.year && createdAt.month == now.month) {
    return 'Bulan Ini';
  } else if (difference.inDays < 30) {
    return 'Bulan Lalu';
  } else {
    final monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${monthNames[createdAt.month - 1]} ${createdAt.year}';
  }
}

DateTime _parseMonthYear(String monthYear) {
  final parts = monthYear.split(' ');
  final monthName = parts[0];
  final year = int.parse(parts[1]);

  final monthNames = {
    'Januari': 1,
    'Februari': 2,
    'Maret': 3,
    'April': 4,
    'Mei': 5,
    'Juni': 6,
    'Juli': 7,
    'Agustus': 8,
    'September': 9,
    'Oktober': 10,
    'November': 11,
    'Desember': 12,
  };

  return DateTime(year, monthNames[monthName]!);
}

String formatMtoKm(double m) {
  return '${(m / 1000).toStringAsFixed(2)} km';
}
