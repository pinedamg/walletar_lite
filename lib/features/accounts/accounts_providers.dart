import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/accounts/data/firestore_service.dart';

// Firestore Service Provider
final accountServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Provider para la lista de cuentas
final accountsProvider = StreamProvider((ref) {
  final service = ref.read(accountServiceProvider);
  return service.accountsCollection.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }).toList(),
      );
});
