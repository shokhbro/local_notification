import 'package:flutter/material.dart';
import 'package:local_notification/controllers/todo_controller.dart';
import 'package:local_notification/views/widgets/add_edit_todo.dart';
import 'package:local_notification/views/widgets/task_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  final TodoController todoController = TodoController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  int id(int index) {
    return index++;
  }

  int selectedIndex = 0;

  void _addTask() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return const TodoAddEditDialog(
          isEditing: false,
        );
      },
    );

    if (result != null) {
      setState(() {
        todoController.addTodo(
          todoController.list.length + 1,
          result['title']!,
          result['description']!,
        );
      });
    }
  }

  void _editTask(int index) async {
    final initialTitle = todoController.list[index].title;
    final initialDescription = todoController.list[index].description;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return TodoAddEditDialog(
          initialTitle: initialTitle,
          initialDescription: initialDescription,
          isEditing: true,
        );
      },
    );

    if (result != null) {
      setState(() {
        todoController.editTodo(
          index,
          result['title']!,
          result['description']!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Todo Screen",
          style: TextStyle(
            fontFamily: 'Extrag',
            color: Colors.white,
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          TabBarView(
            controller: tabController,
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: todoController.list.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                          task: todoController.list[index],
                          onDelete: () {
                            setState(() {
                              todoController.removeTodo(index);
                            });
                          },
                          onEdit: () => _editTask(index),
                          onToggle: () {
                            setState(() {
                              todoController.toggleTodoCompletion(index);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _addTask,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
