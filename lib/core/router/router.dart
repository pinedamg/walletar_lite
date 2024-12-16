import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/auth/auth_providers.dart';
import 'package:walletar_lite/features/auth/presentation/login_screen.dart';
import 'package:walletar_lite/features/auth/presentation/register_screen.dart';
import 'package:walletar_lite/features/home/presentation/home_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
  redirect: (context, state) {
    // Usamos el estado del usuario autenticado
    final authState = ProviderScope.containerOf(context)
        .read(authStateProvider)
        .asData
        ?.value;

    final isLoggingIn =
        state.uri.toString() == '/login' || state.uri.toString() == '/register';
    if (authState == null && !isLoggingIn) {
      return '/login'; // Redirigir al login si no está autenticado
    }
    if (authState != null && isLoggingIn) {
      return '/'; // Redirigir a Home si ya está autenticado
    }
    return null; // Mantener la ruta actual
  },
);