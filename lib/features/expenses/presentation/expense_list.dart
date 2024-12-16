import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';
import 'package:walletar_lite/features/expenses/presentation/expense_item.dart';

class ExpenseList extends ConsumerWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);

    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Center(child: Text('No hay gastos registrados.'));
        }
        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ExpenseItem(expense: expense);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error: ${error.toString()}')),
    );
  }
}
