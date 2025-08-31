import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_todo/domain/models/todo.dart';

const _uuid = Uuid();

final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [
    Todo(id: _uuid.v4(), title: 'Dummy', description: null),
  ];

  void add(String title, String? description) {
    state = [
      ...state,
      Todo(id: _uuid.v4(), title: title, description: description),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            isCompleted: !todo.isCompleted,
            title: todo.title,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({
    required String id,
    required String title,
    required String? description,
  }) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            isCompleted: todo.isCompleted,
            title: title,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
