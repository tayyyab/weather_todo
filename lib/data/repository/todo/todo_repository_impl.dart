import 'package:weather_todo/data/repository/todo/todo_repository.dart';
import 'package:weather_todo/data/services/local/todo/todo_hive_store.dart';
import 'package:weather_todo/domain/models/todo.dart';

class TodoRepositoryImpl extends TodoRepository {
  TodoRepositoryImpl({required TodoHiveStore todoHiveStore})
    : _todoHiveStore = todoHiveStore;

  final TodoHiveStore _todoHiveStore;

  @override
  Future<void> addTodo(Todo todo) async {
    await _todoHiveStore.saveTodo(todo);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await _todoHiveStore.updateTodo(todo);
  }

  @override
  void removeTodo(Todo todo) async {
    await _todoHiveStore.deleteTodo(todo.id);
  }

  @override
  List<Todo> get todos => _todoHiveStore.getAllTodos();
}
