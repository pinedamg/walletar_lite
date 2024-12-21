import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:walletar_lite/features/expenses/data/firestore_service.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class ExpenseItem extends ConsumerWidget {
  final Map<String, dynamic> expense;

  const ExpenseItem({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = expense['monto_pagado'] >= expense['monto_total'];

    return Slidable(
      key: ValueKey(expense['id']),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: _buildStartActions(context, ref),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: _buildEndActions(context, ref),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ExpansionTile(
          leading: Icon(
            isPaid ? Icons.check_circle : Icons.warning_amber_rounded,
            color: isPaid ? Colors.green : Colors.red,
          ),
          // tileColor: isPaid ? Colors.green[100] : Colors.red[100],
          title: Text(expense['label'] ?? 'Sin etiqueta'),
          subtitle: Text(
            '${expense['monto_total']} ${expense['moneda']} - ${expense['tipo_pago']}',
          ),
          trailing: Text(
            expense['fecha'] != null
                ? DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(expense['fecha']))
                : '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPaid ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  // Acciones del lado izquierdo (Eliminar y Editar)
  List<Widget> _buildStartActions(BuildContext context, WidgetRef ref) {
    return [
      SlidableAction(
        onPressed: (context) {
          ref.read(firestoreServiceProvider).deleteExpense(expense['id']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gasto eliminado')),
          );
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Eliminar',
      ),
      SlidableAction(
        onPressed: (context) {
          context.go('/edit-expense', extra: expense);
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        label: 'Editar',
      ),
    ];
  }

  // Acciones del lado derecho (Pago Total, Pago Mínimo, Pago Parcial)
  List<Widget> _buildEndActions(BuildContext context, WidgetRef ref) {
    return [
      SlidableAction(
        onPressed: (context) {
          _markAsPaid(ref, expense['id'], expense['monto_total']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pago Total registrado')),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: Icons.paid,
        label: 'Pago Total',
      ),
      SlidableAction(
        onPressed: (context) {
          _markAsPaid(ref, expense['id'], expense['monto_minimo'] ?? 0);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pago Mínimo registrado')),
          );
        },
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.white,
        icon: Icons.paid_outlined,
        label: 'Pago Mínimo',
      ),
      SlidableAction(
        onPressed: (context) {
          _showPartialPaymentDialog(context, ref);
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        icon: Icons.payment,
        label: 'Pago Parcial',
      ),
    ];
  }

  // Marcar como pagado con el monto especificado
  void _markAsPaid(WidgetRef ref, String id, double amount) {
    ref
        .read(firestoreServiceProvider)
        .updateExpense(id, {'monto_pagado': amount});
  }

  // Mostrar diálogo para pago parcial
  void _showPartialPaymentDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pago Parcial'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monto pagado'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(controller.text) ?? 0;
                if (amount > 0) {
                  _markAsPaid(ref, expense['id'], amount);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Pago Parcial de \$${amount} registrado')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
