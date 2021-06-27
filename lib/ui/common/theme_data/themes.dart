import 'package:flutter/material.dart';

enum AppTheme {
  BlueLight,BlueDark
}
final themeData = {
  AppTheme.BlueLight : ThemeData(brightness: Brightness.light, primaryColor: Colors.blue, cardColor: Colors.grey[200], ),
  AppTheme.BlueDark : ThemeData(brightness: Brightness.dark, primaryColor: Colors.blue[70],),

};