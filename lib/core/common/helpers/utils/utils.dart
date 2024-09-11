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
