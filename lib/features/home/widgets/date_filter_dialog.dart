import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class DateFilterDialog extends ConsumerWidget {
  const DateFilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Filtrar por Fecha'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Hoy'),
            onTap: () {
              ref.read(dateFilterProvider.notifier).state = 'Hoy';
              ref.read(currentMonthProvider.notifier).state = DateTime.now();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Semana Actual'),
            onTap: () {
              ref.read(dateFilterProvider.notifier).state = 'Semana Actual';
              ref.read(currentMonthProvider.notifier).state = DateTime.now();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Hasta el 2do Jueves del mes'),
            onTap: () {
              ref.read(dateFilterProvider.notifier).state =
                  'Hasta el 2do Jueves del mes';
              ref.read(currentMonthProvider.notifier).state = DateTime.now();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Todo el Mes Corriente'),
            onTap: () {
              ref.read(dateFilterProvider.notifier).state =
                  'Todo el Mes Corriente';
              ref.read(currentMonthProvider.notifier).state = DateTime.now();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
