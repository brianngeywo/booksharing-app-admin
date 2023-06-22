import 'package:flutter/material.dart';

class NavigationItem {
  IconData icon;
  String title;
  String imageUrl;
  void Function(BuildContext context) navigate;

  NavigationItem({
    required this.icon,
    required this.title,
    required this.imageUrl,
    required this.navigate,
  });
}
