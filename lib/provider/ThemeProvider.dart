import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  Color _colorSelected = const Color(0xFF102457);

  bool get isDarkTheme => _isDarkTheme;
  Color get colorSelected => _colorSelected;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    int? colorValue = prefs.getInt('colorSelected');
    if (colorValue != null) {
      _colorSelected = Color(colorValue);
    }
    notifyListeners();
  }

  set setThemeDark(bool isDark) {
    _isDarkTheme = isDark;
    _savePreferences();
    notifyListeners();
  }

  void setThemeColor(Color color) {
    _colorSelected = color;
    _savePreferences();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
    await prefs.setInt('colorSelected', _colorSelected.value);
  }
}
