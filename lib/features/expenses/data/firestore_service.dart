import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Añadir un gasto
  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    await _db.collection('gastos').add(expenseData);
  }

  // Obtener gastos en tiempo real
  Stream<List<Map<String, dynamic>>> getExpenses() {
    return _db.collection('gastos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  // Eliminar un gasto
  Future<void> deleteExpense(String id) async {
    await _db.collection('gastos').doc(id).delete();
  }
}
