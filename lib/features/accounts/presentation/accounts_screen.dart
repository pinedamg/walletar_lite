import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar_lite/features/accounts/accounts_providers.dart';
import 'package:walletar_lite/features/home/widgets/fab_menu.dart';
import 'package:walletar_lite/features/side_menu/presentation/side_menu.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
      ),
      drawer: const SideMenu(), // Agregamos el Drawer
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: Text('No hay cuentas registradas.'));
          }
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Slidable(
                key: ValueKey(account['id']),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // Navegar a la pantalla de edición
                        context.go('/edit-account', extra: account);
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Editar',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar Eliminación'),
                            content: const Text(
                                '¿Está seguro de que desea eliminar esta cuenta?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          ref
                              .read(accountServiceProvider)
                              .deleteAccount(account['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cuenta eliminada')),
                          );
                        }
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Eliminar',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(account['nombre'] ?? 'Sin nombre'),
                  subtitle: Text(account['descripcion'] ?? 'Sin descripción'),
                  trailing: Text(account['tipo'] ?? 'Sin tipo'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error: ${error.toString()}')),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const FabMenu(),
    );
  }
}
