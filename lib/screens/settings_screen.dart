import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SwitchListTile(
                title: const Text('Follow Device Theme'),
                value: themeProvider.followSystemTheme,
                onChanged: (value) {
                  themeProvider.toggleFollowSystemTheme(value);
                  print('Follow Device Theme changed: $value');
                },
                secondary: const Icon(Icons.smartphone),
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeProvider.isDarkMode,
                onChanged: themeProvider.followSystemTheme
                    ? null // Disable toggle if following system theme
                    : (value) {
                  themeProvider.toggleTheme();
                  print('Dark Mode: $value');
                },
                secondary: const Icon(Icons.dark_mode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
