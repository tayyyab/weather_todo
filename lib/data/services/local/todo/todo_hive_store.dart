import 'package:hive/hive.dart';
import 'package:weather_todo/data/services/adopter/todo_adopter.dart';
import 'package:weather_todo/domain/models/todo.dart';

class TodoHiveStore {
  TodoHiveStore() {
    init();
  }

  static const String boxName = 'todosBox';
  static const typeBaseId = 1;

  late Box<Todo> _box;

  Future<void> init() async {
    Hive.registerAdapter(TodoAdopter(typeBaseId));
    _box = await Hive.openBox<Todo>(boxName);
  }

  List<Todo> getAllTodos() {
    return _box.values.toList();
  }

  Future<void> saveTodo(Todo todo) async {
    await _box.put(todo.id, todo);
  }

  Future<void> updateTodo(Todo todo) async {
    await _box.put(todo.id, todo);
  }

  Future<Todo?> getTodo(String id) async {
    return _box.get(id);
  }

  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }
}
