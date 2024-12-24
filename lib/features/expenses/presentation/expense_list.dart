import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';
import 'package:walletar_lite/features/expenses/presentation/expense_item.dart';

class ExpenseList extends ConsumerWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredExpenses = ref.watch(filteredExpensesProvider);

    if (filteredExpenses.isEmpty) {
      return const Center(child: Text('No hay gastos registrados.'));
    }

    return ListView.builder(
      itemCount: filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = filteredExpenses[index];
        return ExpenseItem(expense: expense);
      },
    );
  }
}
