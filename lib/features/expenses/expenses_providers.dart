import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/data/firestore_service.dart';
import 'package:walletar_lite/features/expenses/presentation/filter_state.dart';

// Firestore Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Provider para la lista de gastos
final expensesProvider = StreamProvider((ref) {
  final service = ref.read(firestoreServiceProvider);
  return service.expensesCollection.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }).toList(),
      );
});

// Provider para el estado del filtro por fecha
final dateFilterProvider = StateProvider<String>((ref) {
  return 'Todo el Mes Corriente'; // Estado inicial: Mes Corriente
});

// Provider para el estado del filtro
final filterStateProvider = StateProvider<FilterState>((ref) {
  return FilterState.all; // Estado inicial: Sin filtro
});

class CurrentMonthNotifier extends StateNotifier<DateTime> {
  CurrentMonthNotifier() : super(DateTime.now());

  void setPreviousMonth() {
    state = DateTime(state.year, state.month - 1, 1);
  }

  void setNextMonth() {
    state = DateTime(state.year, state.month + 1, 1);
  }

  void setSelectedMonth(DateTime selectedMonth) {
    state = selectedMonth;
  }
}

// Proveedor para el CurrentMonthNotifier
final currentMonthProvider =
    StateNotifierProvider<CurrentMonthNotifier, DateTime>(
        (ref) => CurrentMonthNotifier());

// Actualización del filtro de gastos para usar el currentMonthProvider
final filteredExpensesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final expensesAsync = ref.watch(expensesProvider).asData?.value ?? [];
  final filterState = ref.watch(filterStateProvider);
  final dateFilter = ref.watch(dateFilterProvider);
  final currentMonth = ref.watch(currentMonthProvider);

  // Filtrar por estado de pago
  List<Map<String, dynamic>> filteredExpenses = expensesAsync;
  if (filterState == FilterState.paid) {
    filteredExpenses = filteredExpenses
        .where((expense) =>
            (expense['monto_pagado'] ?? 0) >= (expense['monto_total'] ?? 0))
        .toList();
  } else if (filterState == FilterState.pending) {
    filteredExpenses = filteredExpenses
        .where((expense) =>
            (expense['monto_pagado'] ?? 0) < (expense['monto_total'] ?? 0))
        .toList();
  }

  // Filtrar por fecha
  final now = DateTime.now();
  filteredExpenses = filteredExpenses.where((expense) {
    final expenseDate =
        DateTime.parse(expense['fecha'] ?? now.toIso8601String());

    switch (dateFilter) {
      case 'Hoy':
        return expenseDate.year == now.year &&
            expenseDate.month == now.month &&
            expenseDate.day == now.day;
      case 'Semana Actual':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return expenseDate.isAfter(startOfWeek) &&
            expenseDate.isBefore(endOfWeek);
      case 'Hasta el 2do Jueves del mes':
        final secondThursday =
            DateTime(currentMonth.year, currentMonth.month, 1).add(Duration(
                days: (4 -
                            DateTime(currentMonth.year, currentMonth.month, 1)
                                .weekday) %
                        7 +
                    7));
        return expenseDate.isBefore(secondThursday);
      case 'Todo el Mes Corriente':
      default:
        return expenseDate.year == currentMonth.year &&
            expenseDate.month == currentMonth.month;
    }
  }).toList();

  return filteredExpenses;
});
