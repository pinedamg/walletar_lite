import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/home/widgets/home_header.dart';
import 'package:walletar_lite/features/expenses/presentation/expense_list.dart';
import 'package:walletar_lite/features/side_menu/presentation/side_menu.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime currentMonth = DateTime.now();

  void _loadPreviousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    });
  }

  void _loadNextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    });
  }

  void _filterDate() {
    // Lógica del filtro de fecha
  }

  void _filterStatus() {
    // Lógica del filtro por estado de pago
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: Column(
        children: [
          HomeHeader(
            onFilterDate: _filterDate,
            onFilterStatus: _filterStatus,
            onPreviousMonth: _loadPreviousMonth,
            onNextMonth: _loadNextMonth,
            onMonthSelected: (selected) {
              setState(() => currentMonth = selected);
            },
          ),
          const Expanded(
            child: ExpenseList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-expense'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
