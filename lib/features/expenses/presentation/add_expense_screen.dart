import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar_lite/features/accounts/accounts_providers.dart';
import 'package:walletar_lite/features/expenses/data/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:walletar_lite/features/expenses/expenses_providers.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Gasto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fecha del Gasto
                FormBuilderDateTimePicker(
                  name: 'fecha',
                  initialValue: DateTime.now(),
                  inputType: InputType.date,
                  decoration: const InputDecoration(
                    labelText: 'Fecha del Gasto',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: FormBuilderValidators.required(),
                ),

                // Monto Total
                FormBuilderTextField(
                  name: 'monto_total',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto Total',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),

                // Monto Mínimo
                FormBuilderTextField(
                  name: 'monto_minimo',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto Mínimo',
                    prefixIcon: Icon(Icons.money_off),
                  ),
                  validator: FormBuilderValidators.numeric(),
                ),

                // Monto Pagado
                FormBuilderTextField(
                  name: 'monto_pagado',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto Pagado',
                    prefixIcon: Icon(Icons.payment),
                  ),
                  validator: FormBuilderValidators.numeric(),
                ),

                // Moneda
                FormBuilderDropdown<String>(
                  name: 'moneda',
                  decoration: const InputDecoration(
                    labelText: 'Moneda',
                    prefixIcon: Icon(Icons.currency_exchange),
                  ),
                  initialValue: 'ARS',
                  items: ['ARS', 'USD']
                      .map((moneda) => DropdownMenuItem(
                            value: moneda,
                            child: Text(moneda),
                          ))
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),

                // Tipo de Pago
                FormBuilderRadioGroup<String>(
                  name: 'tipo_pago',
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Pago',
                  ),
                  options: ['Depósito', 'Efectivo', 'Tarjeta']
                      .map((tipo) => FormBuilderFieldOption(value: tipo))
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),

                // Etiqueta (opcional)
                FormBuilderTextField(
                  name: 'label',
                  decoration: const InputDecoration(
                    labelText: 'Etiqueta',
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
// Cuenta Asociada
                FormBuilderDropdown<String>(
                  name: 'accountId',
                  decoration: const InputDecoration(
                    labelText: 'Cuenta Asociada',
                    prefixIcon: Icon(Icons.account_balance),
                  ),
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

                // Descripción
                FormBuilderTextField(
                  name: 'descripcion',
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // Botón de Guardar
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final formData = _formKey.currentState!.value;

                      // Guardar en Firestore
                      final expense = {
                        'fecha':
                            (formData['fecha'] as DateTime).toIso8601String(),
                        'monto_total': double.parse(formData['monto_total']),
                        'monto_minimo':
                            double.tryParse(formData['monto_minimo'] ?? '0') ??
                                0.0,
                        'monto_pagado':
                            double.tryParse(formData['monto_pagado'] ?? '0') ??
                                0.0,
                        'moneda': formData['moneda'],
                        'tipo_pago': formData['tipo_pago'],
                        'label': formData['label'],
                        'descripcion': formData['descripcion'],
                        'accountId': formData[
                            'accountId'], // Aquí incluimos el ID de la cuenta
                        'created_at': DateTime.now().toIso8601String(),
                      };

                      await ref
                          .read(firestoreServiceProvider)
                          .addExpense(expense);

                      await ref
                          .read(firestoreServiceProvider)
                          .addExpense(expense);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Gasto agregado correctamente')),
                      );

                      context.go('/');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Por favor completa todos los campos')),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
