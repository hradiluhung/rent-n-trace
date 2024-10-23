import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_history_card.dart';

class RentHistoryList extends StatelessWidget {
  final Map<String, List<RentHistory>> groupedHistories;
  const RentHistoryList({super.key, required this.groupedHistories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groupedHistories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final key = groupedHistories.keys.elementAt(index);
        final value = groupedHistories.values.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(key, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.h),
            ...value.map((history) => Container(
                padding: EdgeInsets.only(bottom: 2.h),
                child: RentHistoryCard(rentHistory: history))),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}
