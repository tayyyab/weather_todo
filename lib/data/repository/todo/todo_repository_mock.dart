import 'package:weather_todo/data/repository/todo/todo_repository.dart';
import 'package:weather_todo/domain/models/todo.dart';

class TodoRepositoryMock implements TodoRepository {
  final List<Todo> _todos = [];

  @override
  Future<List<Todo>> getTodos() async {
    return List.from(_todos);
  }

  @override
  Future<List<Todo>> get todos async => getTodos();

  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }

  @override
  void removeTodo(Todo todo) {
    _todos.removeWhere((t) => t.id == todo.id);
  }

  clear() => _todos.clear();
}
