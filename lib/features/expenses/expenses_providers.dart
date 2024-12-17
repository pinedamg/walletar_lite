import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/expenses/data/firestore_service.dart';

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
