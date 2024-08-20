import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _followSystemTheme = true;
  ColorScheme? _lightDynamicColorScheme;
  ColorScheme? _darkDynamicColorScheme;

  bool get isDarkMode => _isDarkMode;
  bool get followSystemTheme => _followSystemTheme;

  ThemeProvider() {
    _loadPreferences();
  }

  ColorScheme get colorScheme {
    if (_followSystemTheme) {
      return WidgetsBinding.instance.window.platformBrightness == Brightness.dark
          ? _darkDynamicColorScheme ?? const ColorScheme.dark()
          : _lightDynamicColorScheme ?? const ColorScheme.light();
    }
    return _isDarkMode ? _darkDynamicColorScheme ?? const ColorScheme.dark() : _lightDynamicColorScheme ?? const ColorScheme.light();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _followSystemTheme = false;
    _savePreferences();
    notifyListeners();
  }

  void toggleFollowSystemTheme(bool follow) {
    _followSystemTheme = follow;
    _savePreferences();
    notifyListeners();
  }

  void setDynamicColorSchemes(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    _lightDynamicColorScheme = lightDynamic;
    _darkDynamicColorScheme = darkDynamic;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }


  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _followSystemTheme = prefs.getBool('followSystemTheme') ?? true;
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setBool('followSystemTheme', _followSystemTheme);
  }
}
