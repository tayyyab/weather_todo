import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_todo/data/repository/todo/provider/todo_repository_provider.dart';
import 'package:weather_todo/domain/models/todo.dart';

const _uuid = Uuid();

final todoListProvider = AsyncNotifierProvider<TodoList, List<Todo>>(
  TodoList.new,
);

class TodoList extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    var repoAsync = ref.read(todoRepositoryProvider);
    return repoAsync.when(
      data: (repo) => repo.todos,
      loading: () => <Todo>[],
      error: (error, stack) => <Todo>[],
    );
  }

  Future<void> add(String title, String? description) async {
    var repoAsync = ref.read(todoRepositoryProvider);
    await repoAsync.when(
      data: (repo) async {
        var newTodo = Todo(
          id: _uuid.v4(),
          title: title,
          description: description,
          isCompleted: false,
        );
        repo.addTodo(newTodo);
        var currentState = await future;
        state = AsyncValue.data([...currentState, newTodo]);
      },
      loading: () async {},
      error: (error, stack) async {},
    );
  }

  Future<void> toggle(String id) async {
    var repoAsync = ref.read(todoRepositoryProvider);
    await repoAsync.when(
      data: (repo) async {
        var currentState = await future;
        var newState = [
          for (final todo in currentState)
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
        repo.updateTodo(newState.firstWhere((todo) => todo.id == id));
        state = AsyncValue.data(newState);
      },
      loading: () async {},
      error: (error, stack) async {},
    );
  }

  Future<void> edit({
    required String id,
    required String title,
    required String? description,
  }) async {
    var repoAsync = ref.read(todoRepositoryProvider);
    await repoAsync.when(
      data: (repo) async {
        var currentState = await future;
        var newState = [
          for (final todo in currentState)
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
        repo.updateTodo(newState.firstWhere((todo) => todo.id == id));
        state = AsyncValue.data(newState);
      },
      loading: () async {},
      error: (error, stack) async {},
    );
  }

  Future<void> remove(Todo target) async {
    var repoAsync = ref.read(todoRepositoryProvider);
    await repoAsync.when(
      data: (repo) async {
        repo.removeTodo(target);
        var currentState = await future;
        state = AsyncValue.data(
          currentState.where((todo) => todo.id != target.id).toList(),
        );
      },
      loading: () async {},
      error: (error, stack) async {},
    );
  }
}
