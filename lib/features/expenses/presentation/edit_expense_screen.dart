import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:walletar_lite/features/expenses/data/firestore_service.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class EditExpenseScreen extends ConsumerWidget {
  final Map<String, dynamic> expense;

  const EditExpenseScreen({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Gasto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final formState = _formKey.currentState;
              if (formState?.saveAndValidate() ?? false) {
                final updatedExpense = {
                  'label': formState?.value['label'],
                  'monto_total': double.parse(formState?.value['monto_total']),
                  'monto_pagado':
                      double.parse(formState?.value['monto_pagado']),
                  'tipo_pago': formState?.value['tipo_pago'],
                  'moneda': formState?.value['moneda'],
                  'updated_at': DateTime.now().toIso8601String(),
                };

                ref
                    .read(firestoreServiceProvider)
                    .updateExpense(expense['id'], updatedExpense)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gasto actualizado correctamente'),
                    ),
                  );
                  Navigator.of(context).pop();
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'label': expense['label'],
            'monto_total': expense['monto_total'].toString(),
            'monto_pagado': expense['monto_pagado'].toString(),
            'tipo_pago': expense['tipo_pago'] ?? 'Efectivo',
            'moneda': expense['moneda'] ?? 'ARS',
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'label',
                  decoration: const InputDecoration(labelText: 'Etiqueta'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'monto_total',
                  decoration: const InputDecoration(labelText: 'Monto Total'),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'monto_pagado',
                  decoration: const InputDecoration(labelText: 'Monto Pagado'),
                  keyboardType: TextInputType.number,
                ),
                FormBuilderDropdown(
                  name: 'tipo_pago',
                  decoration: const InputDecoration(labelText: 'Tipo de Pago'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Efectivo', child: Text('Efectivo')),
                    DropdownMenuItem(
                        value: 'Tarjeta Crédito',
                        child: Text('Tarjeta Crédito')),
                    DropdownMenuItem(
                        value: 'Transferencia', child: Text('Transferencia')),
                  ],
                ),
                FormBuilderDropdown(
                  name: 'moneda',
                  decoration: const InputDecoration(labelText: 'Moneda'),
                  items: const [
                    DropdownMenuItem(value: 'ARS', child: Text('ARS')),
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _formKey.currentState?.saveAndValidate();
                    final formData = _formKey.currentState?.value;
                    print(formData); // Para depurar los datos capturados
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
