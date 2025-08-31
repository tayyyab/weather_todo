import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/ui/todo/provider/todo_provided.dart';
import 'package:weather_todo/ui/todo/widget/create_todo_dialog.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    return Scaffold(
      body: todosAsync.when(
        data: (todos) => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Dismissible(
              key: Key(todo.id),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                ref.read(todoListProvider.notifier).remove(todo);
              },
              direction: DismissDirection.endToStart,
              dismissThresholds: const {DismissDirection.endToStart: 0.6},
              confirmDismiss: (direction) async {
                return direction == DismissDirection.endToStart;
              },

              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                leading: IconButton(
                  onPressed: () {
                    ref.read(todoListProvider.notifier).toggle(todo.id);
                  },
                  icon: Icon(
                    todo.isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                  ),
                ),
                title: Text(todo.title),
                subtitle: Text(todo.description ?? 'No Description'),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CreateTodoDialog().open(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
