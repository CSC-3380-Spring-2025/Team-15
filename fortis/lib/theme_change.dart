import 'package:flutter/material.dart';

class ThemeChanger extends ChangeNotifier {
  Color _backgroundColor = Colors.white;
  Color get backgroundColor => _backgroundColor;

  void setColor(Color newColor) {
    _backgroundColor = newColor;
    notifyListeners();
  }
}