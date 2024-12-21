import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/auth/auth_providers.dart';
import 'package:walletar_lite/features/auth/presentation/login_screen.dart';
import 'package:walletar_lite/features/auth/presentation/register_screen.dart';
import 'package:walletar_lite/features/expenses/presentation/add_expense_screen.dart';
import 'package:walletar_lite/features/expenses/presentation/edit_expense_screen.dart';
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
    GoRoute(
      path: '/add-expense',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/edit-expense',
      builder: (context, state) {
        final expense = state.extra as Map<String, dynamic>;
        return EditExpenseScreen(expense: expense);
      },
    ),
    // GoRoute(
    //   path: '/incomes',
    //   builder: (context, state) => const Scaffold(
    //     body: Center(child: Text('Ingresos: Pantalla en construcción')),
    //   ),
    // ),
    // GoRoute(
    //   path: '/reports',
    //   builder: (context, state) =>
    //       const Text('Reportes: Pantalla en construcción'),
    // ),
    // GoRoute(
    //   path: '/exchange-rate',
    //   builder: (context, state) => const Scaffold(
    //     body: Center(
    //         child: Text('Cotización o Moneda: Pantalla en construcción')),
    //   ),
    // ),
    // GoRoute(
    //   path: '/settings',
    //   builder: (context, state) => const Scaffold(
    //     body: Center(child: Text('Configuraciones: Pantalla en construcción')),
    //   ),
    // ),
  ],
  redirect: (context, state) {
    final authState = ProviderScope.containerOf(context)
        .read(authStateProvider)
        .asData
        ?.value;

    final isLoggingIn =
        state.uri.toString() == '/login' || state.uri.toString() == '/register';
    if (authState == null && !isLoggingIn) {
      return '/login';
    }
    if (authState != null && isLoggingIn) {
      return '/';
    }
    return null;
  },
);
