import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import '../widgets/item_form.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item:'),
      ),
      body: ItemForm(
        onSubmit: (title, description) {
          final newItem = Item(
            title: title,
            description: description,
          );
          Provider.of<ItemProvider>(context, listen: false).addItem(newItem);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
