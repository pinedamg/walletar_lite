import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/auth/auth_providers.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos el estado del usuario autenticado desde Firebase
    final user = ref.watch(authStateProvider).asData?.value;

    final userEmail = user?.email ?? "Usuario";
    final userInitial = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : "?";

    return Drawer(
      child: Column(
        children: [
          // Encabezado del Drawer
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userInitial, // Inicial del usuario autenticado
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: Text(
              user?.displayName ?? "Usuario Anónimo",
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(userEmail),
          ),
          // Menús del Drawer
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Gastos'),
            onTap: () {
              context.go('/'); // Navegar a la pantalla de gastos
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Cuentas'),
            onTap: () {
              Navigator.pop(context);
              context.go('/accounts');
            },
          ),

          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Ingresos'),
            onTap: () {
              context.go('/incomes'); // Navegar a la pantalla de ingresos
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reportes'),
            onTap: () {
              context.go('/reports'); // Navegar a la pantalla de reportes
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Cotización o Moneda'),
            onTap: () {
              context
                  .go('/exchange-rate'); // Navegar a la pantalla de cotización
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuraciones'),
            onTap: () {
              context
                  .go('/settings'); // Navegar a la pantalla de configuraciones
            },
          ),
          const Spacer(),
          // Cerrar Sesión
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              final authService = ref.read(authServiceProvider);
              await authService.logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
