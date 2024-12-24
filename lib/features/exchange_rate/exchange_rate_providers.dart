import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/exchange_rate/data/firestore_service.dart';

// Firestore Service Provider para Cotización
final exchangeRateServiceProvider =
    Provider<ExchangeRateFirestoreService>((ref) {
  return ExchangeRateFirestoreService();
});

// Provider para obtener la cotización actual desde Firestore
final exchangeRateProvider = StreamProvider<double>((ref) {
  final service = ref.read(exchangeRateServiceProvider);
  return service.exchangeRateStream();
});
