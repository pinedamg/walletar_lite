import 'package:flutter/material.dart';

class HomeHeaderNavigation extends StatelessWidget {
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final DateTime currentMonth;

  const HomeHeaderNavigation({
    Key? key,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.currentMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPreviousMonth,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}",
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onNextMonth,
        ),
      ],
    );
  }
}
