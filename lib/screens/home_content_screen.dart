import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final items = itemProvider.items;
    return items.isEmpty
        ? Center(
      child: Text(
        'No tasks yet. Use the + button to add a new task.',
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        textAlign: TextAlign.center,
      ),
    )
        : ReorderableListView(
      padding: const EdgeInsets.all(8.0),
      children: items.map((item) {
        final index = items.indexOf(item);
        return _buildItem(context, item, index);
      }).toList(),
      onReorder: (oldIndex, newIndex) {
        itemProvider.moveItem(oldIndex, newIndex);
      },
    );
  }

  Widget _buildItem(BuildContext context, Item item, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: ValueKey(item.title),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: IconButton(
          icon: Icon(
            item.completed ? Icons.check_box : Icons.check_box_outline_blank,
          ),
          onPressed: () {
            Provider.of<ItemProvider>(context, listen: false).toggleCompletion(index);
          },
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.completed ? TextDecoration.lineThrough : null,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          item.description,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
          maxLines: null, // Allow multi-line display
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Provider.of<ItemProvider>(context, listen: false).deleteItem(index);
          },
        ),
        children: [
          for (int i = 0; i < item.subtasks.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: ListTile(
                title: Text(
                  item.subtasks[i].title,
                  style: TextStyle(
                    decoration: item.subtasks[i].completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: Checkbox(
                  value: item.subtasks[i].completed,
                  onChanged: (bool? value) {
                    Provider.of<ItemProvider>(context, listen: false)
                        .toggleSubtaskCompletion(index, i);
                  },
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {
                _showEditItemDialog(context, item, index);
              },
              child: const Text('Edit Task'),
            ),
          ),
        ],
      ),
    );
  }


  void _showAddSubtaskDialog(BuildContext context, int itemIndex) {
    final subtaskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subtask'),
          content: TextField(
            controller: subtaskController,
            decoration: const InputDecoration(labelText: 'Subtask Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final subtaskTitle = subtaskController.text;
                if (subtaskTitle.isNotEmpty) {
                  final newSubtask = Subtask(title: subtaskTitle);
                  Provider.of<ItemProvider>(context, listen: false).addSubtask(itemIndex, newSubtask);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }


  void _showEditItemDialog(BuildContext context, Item item, int index) {
    final titleController = TextEditingController(text: item.title);
    final descriptionController = TextEditingController(text: item.description);
    final List<TextEditingController> subtaskControllers = item.subtasks
        .map((subtask) => TextEditingController(text: subtask.title))
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(child: Text('Edit Task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description (Optional)'),
                      maxLines: null, // Allow multi-line input
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Subtasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                    for (int i = 0; i < item.subtasks.length; i++)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: subtaskControllers[i],
                              decoration: InputDecoration(labelText: 'Subtask ${i + 1}'),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  subtaskControllers.removeAt(i);
                                  item.subtasks.removeAt(i);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          subtaskControllers.add(TextEditingController());
                          item.subtasks.add(Subtask(title: '')); // Add an empty subtask
                        });
                      },
                      child: const Text('Add Subtask'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final title = titleController.text;
                    final description = descriptionController.text;

                    if (title.isNotEmpty) {
                      final updatedSubtasks = subtaskControllers
                          .map((controller) => Subtask(title: controller.text))
                          .where((subtask) => subtask.title.isNotEmpty) // Filter out empty subtasks
                          .toList();

                      if (updatedSubtasks.length != subtaskControllers.length) {
                        // Show an error if any subtask is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Subtasks cannot be empty')),
                        );
                        return;
                      }

                      final updatedItem = Item(
                        title: title,
                        description: description,
                        completed: item.completed,
                        subtasks: updatedSubtasks,
                      );
                      Provider.of<ItemProvider>(context, listen: false).updateItem(index, updatedItem);
                      Navigator.of(context).pop();
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title cannot be empty')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }


}
