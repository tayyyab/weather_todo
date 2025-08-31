import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/services/local/todo/todo_hive_store.dart';

final todoHiveStoreProvider = Provider<TodoHiveStore>((ref) {
  return TodoHiveStore();
});
