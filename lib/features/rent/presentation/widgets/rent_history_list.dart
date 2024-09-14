import 'package:flutter/material.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_history_card.dart';

class RentHistoryList extends StatelessWidget {
  final Map<String, List<RentHistory>> groupedHistories;

  const RentHistoryList({super.key, required this.groupedHistories});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: groupedHistories.entries
          .map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  ...entry.value.map((history) => RentHistoryCard(rentHistory: history)),
                ],
              ))
          .toList(),
    );
  }
}
