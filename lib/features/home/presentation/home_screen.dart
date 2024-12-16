import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletAR Lite - Home'),
        actions: [
          IconButton(
            onPressed: () async {
              // Cierre de sesión y redirección al login
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: expensesAsync.when(
          data: (expenses) {
            if (expenses.isEmpty) {
              return const Center(child: Text('No hay gastos registrados.'));
            }
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense['label'] ?? 'Sin etiqueta'),
                  subtitle: Text('${expense['monto']} ${expense['moneda']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(firestoreServiceProvider)
                          .deleteExpense(expense['id']);
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error: ${error.toString()}')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla para agregar un gasto
          showDialog(
            context: context,
            builder: (context) => AddExpenseDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddExpenseDialog extends ConsumerWidget {
  AddExpenseDialog({Key? key}) : super(key: key);

  final TextEditingController labelController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Agregar Gasto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: labelController,
            decoration: const InputDecoration(labelText: 'Etiqueta'),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Monto'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final label = labelController.text.trim();
            final amount = double.tryParse(amountController.text.trim()) ?? 0.0;

            // if (label.isEmpty || amount <= 0) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text('Datos inválidos')),
            //   );
            //   return;
            // }

            final expense = {
              'label': label,
              'monto': amount,
              'moneda': 'ARS', // Por ahora, fijamos la moneda
              'created_at': DateTime.now().toIso8601String(),
            };

            await ref.read(firestoreServiceProvider).addExpense(expense);
            Navigator.of(context).pop();
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
