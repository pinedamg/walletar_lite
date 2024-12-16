import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/data/firestore_service.dart';

// Proveedor del servicio de Firestore
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Proveedor del flujo de gastos
final expensesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getExpenses();
});
