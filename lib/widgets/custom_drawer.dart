import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
