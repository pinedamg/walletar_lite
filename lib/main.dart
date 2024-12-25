import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar_lite/core/firebase/firebase_initialization_provider.dart';
import 'package:walletar_lite/core/app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyAppBootstrap()));
}

class MyAppBootstrap extends ConsumerWidget {
  const MyAppBootstrap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseInit = ref.watch(firebaseInitializationProvider);

    return firebaseInit.when(
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error inicializando Firebase: $error')),
        ),
      ),
      data: (_) => const AppWidget(),
    );
  }
}
