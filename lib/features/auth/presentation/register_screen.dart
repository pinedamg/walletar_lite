import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/features/auth/auth_providers.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                // Llamar al servicio de autenticación para registrar al usuario
                final user = await authService.register(email, password);

                if (user != null) {
                  // Mostrar Snackbar de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );

                  // Loguear automáticamente y redirigir a la pantalla principal
                  context.go('/'); // Cambia la ruta según tu pantalla principal
                } else {
                  // Mostrar Snackbar de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error en el registro')),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navegar de vuelta a la pantalla de Login
                context.go('/login');
              },
              child: const Text(
                '¿Ya tienes cuenta? Inicia sesión aquí',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
