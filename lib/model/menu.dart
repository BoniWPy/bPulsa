import 'package:flutter/material.dart';

class Menu {
  String title;
  IconData icon;
  String image;
  String targetPage;
  BuildContext context;
  Color menuColor;

  Menu(
      {this.title,
      this.icon,
      this.image,
      this.targetPage,
      this.context,
      this.menuColor = Colors.black});
}
