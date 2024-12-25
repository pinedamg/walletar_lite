import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/auth/data/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Instancia del servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = FirebaseAuth.instance;
  auth.setPersistence(Persistence.LOCAL);
  return auth.authStateChanges();
});
