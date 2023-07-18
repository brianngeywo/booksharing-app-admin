import 'package:admin_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onModuleSelected;

  const Sidebar({required this.onModuleSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.cyan[900],
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            ListTile(
              title: const Text('Users', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  widget.onModuleSelected('users');
                });
              },
            ),
            ListTile(
              title: const Text('Books', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  widget.onModuleSelected('books');
                });
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child:
                  Text("Admin Actions", style: TextStyle(color: Colors.white)),
            ),
            const Divider(),
            ListTile(
              title:
                  const Text('Add User', style: TextStyle(color: Colors.white)),
              onTap: () {
                print(FirebaseAuth.instance.currentUser!.uid);
                setState(() {
                  widget.onModuleSelected('addUser');
                });
              },
            ),
            ListTile(
              title:
                  const Text('Add Book', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  widget.onModuleSelected('addBook');
                });
              },
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Colors.red,
              onPressed: () async {
                await AuthService().logoutUser();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
