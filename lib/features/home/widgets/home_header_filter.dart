import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';
import 'package:walletar_lite/features/expenses/presentation/filter_state.dart';

class HomeHeaderFilter extends ConsumerWidget {
  const HomeHeaderFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterStateProvider);

    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Filtrar por Estado de Pago'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<FilterState>(
                  value: FilterState.all,
                  groupValue: filterState,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(filterStateProvider.notifier).state = value;
                      Navigator.of(context).pop();
                    }
                  },
                  title: const Text('Todos'),
                ),
                RadioListTile<FilterState>(
                  value: FilterState.paid,
                  groupValue: filterState,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(filterStateProvider.notifier).state = value;
                      Navigator.of(context).pop();
                    }
                  },
                  title: const Text('Pagados'),
                ),
                RadioListTile<FilterState>(
                  value: FilterState.pending,
                  groupValue: filterState,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(filterStateProvider.notifier).state = value;
                      Navigator.of(context).pop();
                    }
                  },
                  title: const Text('Pendientes'),
                ),
              ],
            ),
          );
        },
      ),
      child: const Text('Filtrar Estado'),
    );
  }
}
