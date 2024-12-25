import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;

  const PieChartWidget({Key? key, required this.dataMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Distribución de Gastos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250, // Altura del gráfico
            child: PieChart(
              PieChartData(
                sections: dataMap.entries.map((entry) {
                  final value = entry.value;
                  final percentage =
                      (value / dataMap.values.reduce((a, b) => a + b)) * 100;
                  return PieChartSectionData(
                    color: _getRandomColor(),
                    value: value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Generador de colores (opcional para personalizar cada sección)
  Color _getRandomColor() {
    return Colors
        .primaries[DateTime.now().millisecond % Colors.primaries.length];
  }
}
