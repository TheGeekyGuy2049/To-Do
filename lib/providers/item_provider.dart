import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  ItemProvider() {
    loadItems();
  }

  void addItem(Item item) {
    _items.add(item);
    saveItems();
    notifyListeners();
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    saveItems();
    notifyListeners();
  }

  void updateItem(int index, Item updatedItem) {
    _items[index] = updatedItem;
    saveItems();
    notifyListeners();
  }

  void toggleCompletion(int index) {
    _items[index].completed = !_items[index].completed;
    saveItems();
    notifyListeners();
  }

  void toggleSubtaskCompletion(int itemIndex, int subtaskIndex) {
    _items[itemIndex].subtasks[subtaskIndex].completed =
    !_items[itemIndex].subtasks[subtaskIndex].completed;
    saveItems();
    notifyListeners();
  }

  void addSubtask(int itemIndex, Subtask subtask) {
    _items[itemIndex].subtasks.add(subtask);
    saveItems();
    notifyListeners();
  }

  void moveItem(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    saveItems();
    notifyListeners();
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _items.map<Map<String, dynamic>>((item) => item.toMap()).toList(),
    );
    await prefs.setString('items', encodedData);
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('items');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _items = decodedData.map<Item>((item) => Item.fromMap(item)).toList();
      notifyListeners();
    }
  }
}
