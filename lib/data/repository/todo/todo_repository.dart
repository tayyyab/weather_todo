import 'package:weather_todo/domain/models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> get todos;

  void addTodo(Todo todo);
  void updateTodo(Todo newTodo);
  void removeTodo(Todo todo);
}
