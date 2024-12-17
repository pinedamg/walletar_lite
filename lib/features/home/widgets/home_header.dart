import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomeHeader extends StatefulWidget {
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
              onPressed: widget.onFilterDate,
              tooltip: 'Filtrar por fecha',
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: widget.onFilterStatus,
              tooltip: 'Filtrar por estado de pago',
            ),
          ],
        ),

        // Navegación Mensual
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: widget.onPreviousMonth,
              tooltip: 'Mes anterior',
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickedMonth = await showMonthPicker(
                  context: context,
                  initialDate: selectedMonth,
                );
                if (pickedMonth != null) {
                  setState(() => selectedMonth = pickedMonth);
                  widget.onMonthSelected(pickedMonth);
                }
              },
              child: Text(
                '${selectedMonth.year} - ${_monthName(selectedMonth.month)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: widget.onNextMonth,
              tooltip: 'Mes siguiente',
            ),
          ],
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }
}
