import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:walletar_lite/features/home/widgets/date_filter_dialog.dart';
import 'package:walletar_lite/features/home/widgets/home_header_filter.dart';
import 'package:walletar_lite/features/home/widgets/home_header_navigation.dart';
import 'package:walletar_lite/features/home/widgets/payment_filter_dialog.dart';

class HomeHeader extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onFilterDate;
  final VoidCallback onFilterStatus;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final Function(DateTime) onMonthSelected;

  const HomeHeader({
    Key? key,
    required this.onFilterDate,
    required this.onFilterStatus,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(120); // Ajustar la altura
}

class _HomeHeaderState extends State<HomeHeader> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: const Text('Transacciones'),
          actions: [
            IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const DateFilterDialog(),
              ),
              tooltip: 'Filtrar por fecha',
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const PaymentFilterDialog(),
              ),
              tooltip: 'Filtrar por estado de pago',
            ),
          ],
        ),

        // Navegación Mensual
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: HomeHeaderNavigation(
            onPreviousMonth: widget.onPreviousMonth,
            onNextMonth: widget.onNextMonth,
            currentMonth: selectedMonth,
          ),
        ),
      ],
    );
  }
}
