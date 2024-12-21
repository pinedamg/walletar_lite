import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';

class FabMenu extends StatelessWidget {
  const FabMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up, // Expande hacia arriba
      distance: 70.0, // Espaciado entre los botones
      children: [
        // Botón para agregar un gasto
        FloatingActionButton.small(
          heroTag: 'add-expense',
          onPressed: () {
            context.go('/add-expense');
          },
          child: const Icon(Icons.monetization_on),
          tooltip: 'Agregar Gasto',
        ),
        // Botón para agregar un ingreso
        FloatingActionButton.small(
          heroTag: 'add-income',
          onPressed: () {
            context.go('/add-income'); // Ruta para agregar ingresos
          },
          child: const Icon(Icons.attach_money),
          tooltip: 'Agregar Ingreso',
        ),
        // Botón para agregar una cuenta
        FloatingActionButton.small(
          heroTag: 'add-account',
          onPressed: () {
            context.go('/add-account'); // Ruta para agregar cuentas
          },
          child: const Icon(Icons.account_balance),
          tooltip: 'Agregar Cuenta',
        ),
      ],
    );
  }
}
