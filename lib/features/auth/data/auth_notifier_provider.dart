import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// AuthNotifier que maneja el estado del usuario
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    // Escucha los cambios en el estado de autenticación
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    state = null; // Actualiza el estado
  }
}

// Provider del AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});
