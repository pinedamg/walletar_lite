import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Colección de cuentas
  CollectionReference get accountsCollection => _db.collection('accounts');

  // Crear una cuenta
  Future<void> createAccount(Map<String, dynamic> accountData) async {
    try {
      await accountsCollection.add(accountData);
    } catch (e) {
      print('Error al crear la cuenta: $e');
    }
  }

  // Actualizar una cuenta existente
  Future<void> updateAccount(
      String id, Map<String, dynamic> accountData) async {
    try {
      await accountsCollection.doc(id).update(accountData);
    } catch (e) {
      print('Error al actualizar la cuenta: $e');
    }
  }

  // Eliminar una cuenta
  Future<void> deleteAccount(String id) async {
    try {
      await accountsCollection.doc(id).delete();
    } catch (e) {
      print('Error al eliminar la cuenta: $e');
    }
  }
}
