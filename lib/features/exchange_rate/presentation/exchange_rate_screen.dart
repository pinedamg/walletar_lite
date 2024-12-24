import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar_lite/features/exchange_rate/exchange_rate_providers.dart';
import 'package:walletar_lite/features/side_menu/presentation/side_menu.dart';

class ExchangeRateScreen extends ConsumerStatefulWidget {
  const ExchangeRateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExchangeRateScreen> createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends ConsumerState<ExchangeRateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final exchangeRateAsync = ref.watch(exchangeRateProvider);

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('Cotización'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              exchangeRateAsync.when(
                data: (rate) {
                  return FormBuilderTextField(
                    name: 'rate',
                    initialValue: rate.toStringAsFixed(2),
                    decoration: const InputDecoration(
                      labelText: '1 USD es igual a ARS',
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0),
                    ]),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;
                    final rate = double.parse(formData['rate']);

                    await ref
                        .read(exchangeRateServiceProvider)
                        .setExchangeRate(rate);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cotización actualizada')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Por favor ingrese un valor válido')),
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
