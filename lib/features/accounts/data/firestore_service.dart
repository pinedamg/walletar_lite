import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walletar_lite/features/accounts/models/account_model.dart';

class AccountFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get accountsCollection => _db.collection('accounts');

  // Obtener lista de cuentas
  Stream<List<Account>> getAccounts() {
    return accountsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Account.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Crear una nueva cuenta
  Future<void> createAccount(Account account) async {
    await accountsCollection.add(account.toFirestore());
  }

  // Actualizar una cuenta existente
  Future<void> updateAccount(String id, Account account) async {
    await accountsCollection.doc(id).update(account.toFirestore());
  }

  // Eliminar una cuenta
  Future<void> deleteAccount(String id) async {
    await accountsCollection.doc(id).delete();
  }
}
