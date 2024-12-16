import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar_lite/features/expenses/presentation/expense_list.dart';
import 'package:walletar_lite/features/side_menu/presentation/side_menu.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<SliderDrawerState> _drawerKey =
      GlobalKey<SliderDrawerState>();

  String _title = 'WalletAR Lite - Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('WalletAR Lite | Home'),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         context.go('/login');
      //       },
      //       icon: const Icon(Icons.logout),
      //       tooltip: 'Cerrar sesión',
      //     ),
      //   ],
      // ),
      body: SliderDrawer(
        key: _drawerKey,
        appBar: SliderAppBar(
          appBarColor: Colors.white,
          title: Text(
            _title,
            style: const TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
        slider: Container(
          color: Colors.white,
          child: SideMenu(
            onItemSelected: (item) {
              setState(() {
                _title = item;
              });
              if (item == 'Cerrar Sesión') {
                context.go('/login');
              }
              _drawerKey.currentState?.closeSlider();
            },
          ),
        ),
        child: Container(
          color: Colors.white,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: ExpenseList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add-expense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
