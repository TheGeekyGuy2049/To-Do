import 'package:flutter/material.dart';

class ItemForm extends StatefulWidget {
  final Function(String, String) onSubmit;

  ItemForm({super.key, required this.onSubmit});

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submitForm() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      return;
    }

    widget.onSubmit(title, description);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
