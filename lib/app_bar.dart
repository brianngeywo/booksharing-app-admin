import 'package:flutter/material.dart';

AppBar myAppBar({required String title}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(title, style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.cyan[900],
  );
}
