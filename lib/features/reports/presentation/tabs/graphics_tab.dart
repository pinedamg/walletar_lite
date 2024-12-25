import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class GraphicsTab extends ConsumerWidget {
  const GraphicsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(filteredExpensesProvider);

    // Calcular la distribución por tipo de pago
    final distribution = _calculateDistribution(expenses);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Distribución de Gastos por Tipo de Pago',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: _generatePieChartSections(distribution),
                centerSpaceRadius: 40,
                sectionsSpace: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _calculateDistribution(
      List<Map<String, dynamic>> expenses) {
    final Map<String, double> distribution = {
      'Efectivo': 0,
      'Tarjeta': 0,
      'Transferencia': 0,
    };

    for (final expense in expenses) {
      final tipoPago = expense['tipo_pago'] ?? 'Efectivo';
      final monto = expense['monto_total'] ?? 0.0;
      distribution[tipoPago] = (distribution[tipoPago] ?? 0) + monto;
    }

    return distribution;
  }

  List<PieChartSectionData> _generatePieChartSections(
      Map<String, double> distribution) {
    final total = distribution.values.fold(0.0, (sum, value) => sum + value);
    final List<Color> colors = [Colors.blue, Colors.red, Colors.green];

    final entriesList = distribution.entries.toList(); // Convertir a lista

    return entriesList.asMap().entries.map((entry) {
      final index = entry.key;
      final tipoPago = entry.value.key;
      final monto = entry.value.value;
      final percentage = total > 0 ? (monto / total) * 100 : 0;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: monto,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
