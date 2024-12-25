import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/accounts/models/account_model.dart';
import 'package:walletar_lite/features/accounts/presentation/accounts_screen.dart';
import 'package:walletar_lite/features/accounts/presentation/add_account_screen.dart';
import 'package:walletar_lite/features/accounts/presentation/edit_account_screen.dart';
import 'package:walletar_lite/features/auth/auth_providers.dart';
import 'package:walletar_lite/features/auth/data/auth_notifier_provider.dart';
import 'package:walletar_lite/features/auth/presentation/login_screen.dart';
import 'package:walletar_lite/features/auth/presentation/register_screen.dart';
import 'package:walletar_lite/features/exchange_rate/presentation/exchange_rate_screen.dart';
import 'package:walletar_lite/features/expenses/presentation/add_expense_screen.dart';
import 'package:walletar_lite/features/expenses/presentation/edit_expense_screen.dart';
import 'package:walletar_lite/features/home/presentation/home_screen.dart';
import 'package:walletar_lite/features/reports/presentation/reports_screen.dart';

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
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    GoRoute(
      path: '/add-account',
      builder: (context, state) => const AddAccountScreen(),
    ),
    GoRoute(
      path: '/edit-account',
      builder: (context, state) {
        final account = state.extra as Account;
        return EditAccountScreen(account: account);
      },
    ),
    GoRoute(
      path: '/exchange-rate',
      builder: (context, state) => const ExchangeRateScreen(),
    ),
    GoRoute(
      path: '/incomes',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Ingresos: Pantalla en construcción')),
      ),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Configuraciones: Pantalla en construcción')),
      ),
    ),
  ],
  redirect: (context, state) {
    final user = ProviderScope.containerOf(context).read(authNotifierProvider);

    final isLoggingIn =
        state.uri.toString() == '/login' || state.uri.toString() == '/register';

    if (user == null && !isLoggingIn) {
      return '/login';
    }

    if (user != null && isLoggingIn) {
      return '/';
    }

    return null;
  },
);
