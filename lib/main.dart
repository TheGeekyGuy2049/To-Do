import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'providers/item_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              themeProvider.setDynamicColorSchemes(lightDynamic, darkDynamic);

              return MaterialApp(
                title: 'To-Do App',
                theme: ThemeData.from(colorScheme: themeProvider.colorScheme),
                home: const HomeScreen(),
                routes: {
                  SettingsScreen.routeName: (ctx) => const SettingsScreen(),
                  ProfileScreen.routeName: (ctx) => const ProfileScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
