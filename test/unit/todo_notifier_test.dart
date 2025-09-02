import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_todo/data/repository/todo/provider/todo_repository_provider.dart';
import 'package:weather_todo/data/repository/todo/todo_repository_mock.dart';
import 'package:weather_todo/domain/models/todo.dart';
import 'package:weather_todo/ui/todo/provider/todo_provided.dart';

void main() {
  group('TodoList Notifier Tests', () {
    late TodoRepositoryMock fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = TodoRepositoryMock();
      container = ProviderContainer(
        overrides: [
          todoRepositoryProvider.overrideWith((ref) async => fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      fakeRepository.clear();
    });

    group('build()', () {
      test('should load todos from repository on initialization', () async {
        final expectedTodos = [
          const Todo(
            id: '1',
            title: 'Test Todo 1',
            description: 'Description 1',
          ),
          const Todo(
            id: '2',
            title: 'Test Todo 2',
            description: 'Description 2',
          ),
        ];
        for (var todo in expectedTodos) {
          fakeRepository.addTodo(todo);
        }

        final asyncValue = await container.read(todoListProvider.future);

        expect(asyncValue, expectedTodos);
        expect(asyncValue.length, 2);
      });

      test('should handle empty todo list', () async {
        final asyncValue = await container.read(todoListProvider.future);

        expect(asyncValue, isEmpty);
      });
    });

    group('add()', () {
      test('should add new todo to the list', () async {
        // Arrange
        final initialTodos = [
          const Todo(id: '1', title: 'Existing Todo', description: 'Existing'),
        ];
        for (var todo in initialTodos) {
          fakeRepository.addTodo(todo);
        }

        // Wait for initial state
        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.add('New Todo', 'New Description');

        // Assert
        final currentState = await container.read(todoListProvider.future);
        expect(currentState.length, 2);
        expect(currentState.last.title, 'New Todo');
        expect(currentState.last.description, 'New Description');
        expect(currentState.last.isCompleted, false);
        expect((await fakeRepository.todos).length, 2);
      });

      test('should add todo with null description', () async {
        // Arrange - empty repository
        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.add('Todo without description', null);

        // Assert
        final currentState = await container.read(todoListProvider.future);
        expect(currentState.length, 1);
        expect(currentState.first.title, 'Todo without description');
        expect(currentState.first.description, null);
      });

      test('should generate unique IDs for todos', () async {
        // Arrange
        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.add('Todo 1', 'Description 1');
        await notifier.add('Todo 2', 'Description 2');

        // Assert
        final currentState = await container.read(todoListProvider.future);
        expect(currentState.length, 2);
        expect(currentState[0].id, isNot(equals(currentState[1].id)));
        expect(currentState[0].id, isNotEmpty);
        expect(currentState[1].id, isNotEmpty);
      });
    });

    group('toggle()', () {
      test('should toggle todo completion status', () async {
        // Arrange
        final initialTodos = [
          const Todo(
            id: '1',
            title: 'Todo 1',
            description: 'Desc 1',
            isCompleted: false,
          ),
          const Todo(
            id: '2',
            title: 'Todo 2',
            description: 'Desc 2',
            isCompleted: true,
          ),
        ];
        for (var todo in initialTodos) {
          fakeRepository.addTodo(todo);
        }

        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.toggle('1');

        // Assert
        final currentState = await container.read(todoListProvider.future);
        expect(currentState[0].isCompleted, true);
        expect(currentState[1].isCompleted, true); // Should remain unchanged
        expect((await fakeRepository.todos)[0].isCompleted, true);
      });

      test('should not change other todo properties when toggling', () async {
        // Arrange
        final initialTodos = [
          const Todo(
            id: '1',
            title: 'Important Todo',
            description: 'Important task',
            isCompleted: false,
          ),
        ];
        for (var todo in initialTodos) {
          fakeRepository.addTodo(todo);
        }

        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.toggle('1');

        // Assert
        final currentState = await container.read(todoListProvider.future);
        final toggledTodo = currentState[0];
        expect(toggledTodo.id, '1');
        expect(toggledTodo.title, 'Important Todo');
        expect(toggledTodo.description, 'Important task');
        expect(toggledTodo.isCompleted, true);
      });
    });

    group('remove()', () {
      test('should remove todo from the list', () async {
        // Arrange
        final todoToRemove = const Todo(
          id: '2',
          title: 'Todo to Remove',
          description: 'Remove me',
        );
        final initialTodos = [
          const Todo(id: '1', title: 'Todo 1', description: 'Keep me'),
          todoToRemove,
          const Todo(id: '3', title: 'Todo 3', description: 'Keep me too'),
        ];
        for (var todo in initialTodos) {
          fakeRepository.addTodo(todo);
        }

        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.remove(todoToRemove);

        // Assert
        final currentState = await container.read(todoListProvider.future);
        expect(currentState.length, 2);
        expect(currentState.any((todo) => todo.id == '2'), false);
        expect(currentState.any((todo) => todo.id == '1'), true);
        expect(currentState.any((todo) => todo.id == '3'), true);
        expect((await fakeRepository.todos).length, 2);
      });

      test('should handle removing from empty list', () async {
        // Arrange
        final todoToRemove = const Todo(
          id: '1',
          title: 'Non-existent',
          description: null,
        );

        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.remove(todoToRemove);

        // Assert
        final currentState = await container.read(todoListProvider.future);
        expect(currentState, isEmpty);
        expect(await fakeRepository.todos, isEmpty);
      });

      test('should remove only the specified todo', () async {
        // Arrange
        final todo1 = const Todo(
          id: '1',
          title: 'Todo 1',
          description: 'First',
        );
        final todo2 = const Todo(
          id: '2',
          title: 'Todo 2',
          description: 'Second',
        );
        final initialTodos = [todo1, todo2];
        for (var todo in initialTodos) {
          fakeRepository.addTodo(todo);
        }

        await container.read(todoListProvider.future);
        final notifier = container.read(todoListProvider.notifier);

        // Act
        await notifier.remove(todo1);

        // Assert
        final currentState = await container.read(todoListProvider.future);
        expect(currentState.length, 1);
        expect(currentState.first.id, '2');
        expect(currentState.first.title, 'Todo 2');
      });
    });
  });
}
