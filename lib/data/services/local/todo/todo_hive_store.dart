import 'package:flutter/foundation.dart' show debugPrint;
import 'package:hive/hive.dart';
import 'package:weather_todo/data/services/adopter/todo_adopter.dart';
import 'package:weather_todo/domain/models/todo.dart';

class TodoHiveStore {
  static const String boxName = 'todosBox';
  static const typeBaseId = 1;

  Box<Todo>? _box;
  static TodoHiveStore? _instance;

  TodoHiveStore._();

  static Future<TodoHiveStore> getInstance() async {
    if (_instance == null) {
      _instance = TodoHiveStore._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    try {
      if (!Hive.isAdapterRegistered(typeBaseId)) {
        Hive.registerAdapter(TodoAdopter(typeBaseId));
      }
      _box = await Hive.openBox<Todo>(boxName);
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      rethrow;
    }
  }

  Box<Todo> get _safeBox {
    if (_box == null) {
      throw StateError(
        'TodoHiveStore not initialized. Call getInstance() first.',
      );
    }
    return _box!;
  }

  List<Todo> getAllTodos() {
    return _safeBox.values.toList();
  }

  Future<void> saveTodo(Todo todo) async {
    await _safeBox.put(todo.id, todo);
  }

  Future<void> updateTodo(Todo todo) async {
    await _safeBox.put(todo.id, todo);
  }

  Future<Todo?> getTodo(String id) async {
    return _safeBox.get(id);
  }

  Future<void> deleteTodo(String id) async {
    await _safeBox.delete(id);
  }
}
