import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar_lite/features/accounts/accounts_providers.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
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
            'accountId': expense['accountId'],
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
                FormBuilderDropdown<String>(
                  name: 'accountId',
                  decoration:
                      const InputDecoration(labelText: 'Cuenta Asociada'),
                  items: ref.watch(accountsProvider).when(
                        data: (accounts) => accounts
                            .map((account) => DropdownMenuItem(
                                  value: account.id,
                                  child: Text(account.nombre),
                                ))
                            .toList(),
                        loading: () => [],
                        error: (error, stack) => [],
                      ),
                  validator: FormBuilderValidators.required(),
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
                    final formState = _formKey.currentState;
                    if (formState?.saveAndValidate() ?? false) {
                      final updatedExpense = {
                        'label': formState?.value['label'],
                        'monto_total':
                            double.parse(formState?.value['monto_total']),
                        'monto_pagado':
                            double.parse(formState?.value['monto_pagado']),
                        'tipo_pago': formState?.value['tipo_pago'],
                        'moneda': formState?.value['moneda'],
                        'accountId': formState?.value['accountId'],
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
                        context.go('/');
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, complete todos los campos'),
                        ),
                      );
                    }
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
