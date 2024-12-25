import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class SummaryTab extends ConsumerWidget {
  const SummaryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(filteredExpensesProvider);

    // Calcular totales
    final totalGasto = expenses.fold<double>(
      0,
      (sum, expense) => sum + (expense['monto_total'] ?? 0),
    );
    final pagosParciales = expenses.fold<double>(
      0,
      (sum, expense) => sum + (expense['monto_pagado'] ?? 0),
    );
    final saldoRestante = totalGasto - pagosParciales;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen General',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            context,
            'Gasto Total',
            totalGasto.toStringAsFixed(2),
            Colors.blue,
          ),
          _buildSummaryItem(
            context,
            'Pagos Parciales',
            pagosParciales.toStringAsFixed(2),
            Colors.orange,
          ),
          _buildSummaryItem(
            context,
            'Saldo Restante',
            saldoRestante.toStringAsFixed(2),
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.pie_chart, color: color),
        ),
        title: Text(title),
        trailing: Text(
          '\$$value',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
