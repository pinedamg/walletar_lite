import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar_lite/features/accounts/accounts_providers.dart';
import 'package:walletar_lite/features/accounts/models/account_model.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cuenta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/accounts');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'nombre',
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(50),
                ]),
              ),
              const SizedBox(height: 16.0),
              FormBuilderDropdown<String>(
                name: 'tipo',
                decoration: const InputDecoration(labelText: 'Tipo de Cuenta'),
                items: ['Bancaria', 'Tarjeta de Crédito', 'Efectivo']
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'etiqueta',
                decoration: const InputDecoration(labelText: 'Etiqueta'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(30),
                ]),
              ),
              const SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'descripcion',
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;

                    final account = Account(
                      id: '', // El ID se genera automáticamente en Firestore
                      nombre: formData['nombre'] as String,
                      tipo: formData['tipo'] as String,
                      etiqueta: formData['etiqueta'] as String,
                      descripcion: formData['descripcion'] as String? ?? '',
                    );

                    await ref
                        .read(accountServiceProvider)
                        .createAccount(account);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cuenta creada con éxito')),
                    );
                    context.go('/accounts');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Por favor, complete todos los campos')),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
