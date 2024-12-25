import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'tabs/summary_tab.dart';
import 'tabs/graphics_tab.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de tabs: Summary y Graphics
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reportes'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.summarize), text: 'Resumen'),
              Tab(icon: Icon(Icons.pie_chart), text: 'Gráficos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SummaryTab(), // Tab Resumen
            GraphicsTab(), // Tab Gráficos
          ],
        ),
      ),
    );
  }
}
