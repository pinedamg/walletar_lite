import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';
import 'package:walletar_lite/features/home/widgets/fab_menu.dart';
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

  void _filterDate() {
    // Lógica del filtro de fecha
  }

  void _filterStatus() {
    // Lógica del filtro por estado de pago
  }

  void _loadPreviousMonth() {
    final currentMonth = ref.read(currentMonthProvider);
    ref.read(currentMonthProvider.notifier).state = DateTime(
      currentMonth.year,
      currentMonth.month - 1,
    );
  }

  void _loadNextMonth() {
    final currentMonth = ref.read(currentMonthProvider);
    ref.read(currentMonthProvider.notifier).state = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    final selectedMonth = await showMonthPicker(
      context: context,
      initialDate: ref.read(currentMonthProvider),
      firstDate: DateTime(DateTime.now().year - 5, 1),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1),
    );
    if (selectedMonth != null) {
      ref.read(currentMonthProvider.notifier).state = selectedMonth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: HomeHeader(
        onFilterDate: _filterDate,
        onFilterStatus: _filterStatus,
        onPreviousMonth: _loadPreviousMonth,
        onNextMonth: _loadNextMonth,
        onMonthSelected: (selected) {
          setState(() => currentMonth = selected);
        },
      ),
      body: const ExpenseList(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const FabMenu(),
    );
  }
}
