import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(String)? onItemSelected;

  const SideMenu({Key? key, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Inicio', style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected?.call('Inicio'),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Configuraciones',
                style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected?.call('Configuraciones'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Cerrar Sesión',
                style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected?.call('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
