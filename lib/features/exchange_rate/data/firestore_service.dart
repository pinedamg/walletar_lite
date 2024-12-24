import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeRateFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Colección de cotización
  CollectionReference get exchangeRateCollection =>
      _db.collection('exchangeRate');

  // Stream para obtener la cotización actual
  Stream<double> exchangeRateStream() {
    return exchangeRateCollection
        .doc('usdToArs') // Documento único para USD a ARS
        .snapshots()
        .map((doc) => doc.exists ? (doc['rate'] as double) : 0.0);
  }

  // Guardar o actualizar la cotización
  Future<void> setExchangeRate(double rate) async {
    await exchangeRateCollection.doc('usdToArs').set({'rate': rate});
  }
}
