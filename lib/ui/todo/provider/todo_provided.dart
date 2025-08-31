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
    // Wait for the repository to be available
    final repo = await ref.watch(todoRepositoryProvider.future);
    // Get todos from the repository
    final todos = await repo.getTodos();
    return todos;
  }

  Future<void> add(String title, String? description) async {
    final repo = await ref.read(todoRepositoryProvider.future);
    var newTodo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      isCompleted: false,
    );
    repo.addTodo(newTodo);

    // Update the state
    var currentState = await future;
    state = AsyncValue.data([...currentState, newTodo]);
  }

  Future<void> toggle(String id) async {
    final repo = await ref.read(todoRepositoryProvider.future);
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
  }

  Future<void> edit({
    required String id,
    required String title,
    required String? description,
  }) async {
    final repo = await ref.read(todoRepositoryProvider.future);
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
  }

  Future<void> remove(Todo target) async {
    final repo = await ref.read(todoRepositoryProvider.future);
    repo.removeTodo(target);
    var currentState = await future;
    state = AsyncValue.data(
      currentState.where((todo) => todo.id != target.id).toList(),
    );
  }
}
