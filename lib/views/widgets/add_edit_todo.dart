import 'package:flutter/material.dart';

class TodoAddEditDialog extends StatelessWidget {
  final String? initialTitle;
  final String? initialDescription;
  final bool isEditing;

  const TodoAddEditDialog({
    this.initialTitle,
    this.initialDescription,
    required this.isEditing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: initialTitle);
    final TextEditingController descriptionController =
        TextEditingController(text: initialDescription);

    return AlertDialog(
      title: Text(isEditing ? 'Rejani tahrirlash' : 'Reja qo\'shish'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Reja nomini kiriting'),
          ),
          TextField(
            controller: descriptionController,
            decoration:
                const InputDecoration(hintText: 'Reja tavsifini kiriting'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Bekor qilish'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'title': titleController.text,
              'description': descriptionController.text
            });
          },
          child: const Text('Saqlash'),
        ),
      ],
    );
  }
}
