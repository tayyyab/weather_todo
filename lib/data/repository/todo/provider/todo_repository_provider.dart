import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/repository/todo/todo_repository.dart';
import 'package:weather_todo/data/repository/todo/todo_repository_impl.dart';
import 'package:weather_todo/data/services/local/todo/provider/todo_hive_provider.dart';

final todoRepositoryProvider = FutureProvider<TodoRepository>((ref) async {
  final todoHiveStore = await ref.watch(todoHiveStoreProvider.future);
  return TodoRepositoryImpl(todoHiveStore: todoHiveStore);
});
