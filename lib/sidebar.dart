import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onModuleSelected;

  const Sidebar({required this.onModuleSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Users'),
            onTap: () {
              onModuleSelected('users');
            },
          ),
          ListTile(
            title: const Text('Books'),
            onTap: () {
              onModuleSelected('books');
            },
          ),
        ],
      ),
    );
  }
}
