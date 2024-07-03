class Todo {
  final int id;
  String title;
  String description;
  final DateTime date;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}
