import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/repository/todo/todo_repository.dart';
import 'package:weather_todo/data/repository/todo/todo_repository_impl.dart';
import 'package:weather_todo/data/services/local/todo/provider/todo_hive_provider.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final todoHiveStore = ref.watch(todoHiveStoreProvider);
  return TodoRepositoryImpl(todoHiveStore: todoHiveStore);
});
