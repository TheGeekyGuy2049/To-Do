import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/item_provider.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'home_content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeContentScreen(),
      const SettingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
        title: const Center(child: Text('To-Do List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)),
      )
          : null,
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outlined),
            label: 'About',
          )
        ],
      ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      )
          : null, // Hide FAB on other screens
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Add New Task')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;

                if (title.isNotEmpty) {
                  final newItem = Item(title: title, description: description);
                  Provider.of<ItemProvider>(context, listen: false).addItem(newItem);
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  const SnackBar(content: Text('Tasks cannot be empty'));
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
