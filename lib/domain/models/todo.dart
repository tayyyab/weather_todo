import 'package:flutter/foundation.dart' show immutable;

@immutable
class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'ToDo{id: $id, title: $title, description: $description, isCompleted: $isCompleted}';
  }
}
