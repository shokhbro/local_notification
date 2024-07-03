import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_notification/models/todo.dart';

class TaskItem extends StatelessWidget {
  final Todo task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  TaskItem({
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // DateFormat obyekti
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onToggle(),
        ),
        title: Text(task.title),
        subtitle: Text(
          "${task.description}\n${dateFormat.format(task.date)}",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
