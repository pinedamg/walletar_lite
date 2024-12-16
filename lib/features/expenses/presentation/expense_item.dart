import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class ExpenseItem extends ConsumerWidget {
  final Map<String, dynamic> expense;

  const ExpenseItem({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: ValueKey(expense['id']),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
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
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pago Total')),
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.paid,
            label: 'Pago Total',
          ),
          SlidableAction(
            onPressed: (context) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pago Minimo')),
              );
            },
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
            icon: Icons.paid_outlined,
            label: 'Pago Minimo',
          ),
        ],
      ),
      child: ListTile(
        title: Text(expense['label'] ?? 'Sin etiqueta'),
        subtitle: Text(
          '${expense['monto_total']} ${expense['moneda']} - ${expense['tipo_pago']}',
        ),
        trailing: Text(
          expense['fecha'] != null
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(expense['fecha']))
              : '',
        ),
      ),
    );
  }
}
