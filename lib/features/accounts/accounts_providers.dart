import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/accounts/data/firestore_service.dart';
import 'package:walletar_lite/features/accounts/models/account_model.dart';

// Firestore Service Provider
final accountServiceProvider = Provider<AccountFirestoreService>((ref) {
  return AccountFirestoreService();
});

// Provider para obtener lista de cuentas
final accountsProvider = StreamProvider<List<Account>>((ref) {
  final service = ref.read(accountServiceProvider);
  return service.getAccounts();
});
