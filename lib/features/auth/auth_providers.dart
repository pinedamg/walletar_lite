import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/auth/data/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Instancia del servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Estado del usuario autenticado
final authStateProvider = StreamProvider<User?>((ref) {
  ref.watch(authServiceProvider);
  return FirebaseAuth.instance.authStateChanges();
});
