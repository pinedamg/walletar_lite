import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  // Agregar un nuevo gasto
  Future<void> addExpense(Map<String, dynamic> expense) async {
    await expensesCollection.add(expense);
  }

  // Actualizar un gasto existente
  Future<void> updateExpense(
      String id, Map<String, dynamic> updatedData) async {
    await expensesCollection.doc(id).update(updatedData);
  }

  // Eliminar un gasto
  Future<void> deleteExpense(String id) async {
    await expensesCollection.doc(id).delete();
  }
}
