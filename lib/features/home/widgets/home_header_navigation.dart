import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class HomeHeaderNavigation extends ConsumerWidget {
  const HomeHeaderNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(currentMonthProvider);
    final currentMonthNotifier = ref.read(currentMonthProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentMonthNotifier.setPreviousMonth,
        ),
        GestureDetector(
          onTap: () async {
            final selectedMonth = await showMonthPicker(
              context: context,
              initialDate: currentMonth,
              firstDate: DateTime(DateTime.now().year - 5, 1),
              lastDate: DateTime(DateTime.now().year + 1, 12),
            );
            if (selectedMonth != null) {
              currentMonthNotifier.setSelectedMonth(selectedMonth);
            }
          },
          child: Text(
            "${currentMonth.year} - ${currentMonth.month.toString().padLeft(2, '0')}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentMonthNotifier.setNextMonth,
        ),
      ],
    );
  }
}
