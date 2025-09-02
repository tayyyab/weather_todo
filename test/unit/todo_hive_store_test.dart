import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:weather_todo/data/services/adopter/todo_adopter.dart';
import 'package:weather_todo/data/services/local/todo/todo_hive_store.dart';
import 'package:weather_todo/domain/models/todo.dart';

void main() {
  group('TodoHiveStore Tests', () {
    late TodoHiveStore todoHiveStore;

    setUpAll(() async {
      // Initialize Hive with a test directory
      Hive.init('.dart_tool/test/hive');
      
      // Register the adapter if not already registered
      if (!Hive.isAdapterRegistered(TodoHiveStore.typeBaseId)) {
        Hive.registerAdapter(TodoAdopter(TodoHiveStore.typeBaseId));
      }
      
      // Get the singleton instance
      todoHiveStore = await TodoHiveStore.getInstance();
    });

    setUp(() async {
      // Clear any existing data before each test
      try {
        if (Hive.isBoxOpen(TodoHiveStore.boxName)) {
          final box = Hive.box<Todo>(TodoHiveStore.boxName);
          await box.clear();
        }
      } catch (e) {
        // Box might not be open, that's okay
      }
    });

    tearDownAll(() async {
      // Close all boxes and clean up
      try {
        await Hive.close();
      } catch (e) {
        // Ignore errors during cleanup
      }
    });

    group('getInstance()', () {
      test('should return the same instance when called multiple times', () async {
        // Act
        final instance1 = await TodoHiveStore.getInstance();
        final instance2 = await TodoHiveStore.getInstance();

        // Assert
        expect(instance1, same(instance2));
      });

      test('should initialize successfully', () async {
        // Act
        final instance = await TodoHiveStore.getInstance();

        // Assert
        expect(instance, isNotNull);
        expect(Hive.isBoxOpen(TodoHiveStore.boxName), isTrue);
      });
    });

    group('saveTodo()', () {
      test('should save a todo successfully', () async {
        // Arrange
        const todo = Todo(
          id: 'test-id-1',
          title: 'Test Todo',
          description: 'Test Description',
          isCompleted: false,
        );

        // Act
        await todoHiveStore.saveTodo(todo);

        // Assert
        final savedTodo = await todoHiveStore.getTodo('test-id-1');
        expect(savedTodo, isNotNull);
        expect(savedTodo!.id, todo.id);
        expect(savedTodo.title, todo.title);
        expect(savedTodo.description, todo.description);
        expect(savedTodo.isCompleted, todo.isCompleted);
      });

      test('should overwrite existing todo with same ID', () async {
        // Arrange
        const originalTodo = Todo(
          id: 'test-id-1',
          title: 'Original Title',
          description: 'Original Description',
          isCompleted: false,
        );
        const updatedTodo = Todo(
          id: 'test-id-1',
          title: 'Updated Title',
          description: 'Updated Description',
          isCompleted: true,
        );

        // Act
        await todoHiveStore.saveTodo(originalTodo);
        await todoHiveStore.saveTodo(updatedTodo);

        // Assert
        final savedTodo = await todoHiveStore.getTodo('test-id-1');
        expect(savedTodo!.title, 'Updated Title');
        expect(savedTodo.description, 'Updated Description');
        expect(savedTodo.isCompleted, true);
        
        final allTodos = todoHiveStore.getAllTodos();
        expect(allTodos.length, 1); // Should still be only one todo
      });

      test('should save todo with null description', () async {
        // Arrange
        const todo = Todo(
          id: 'test-id-null',
          title: 'Todo without description',
          description: null,
        );

        // Act
        await todoHiveStore.saveTodo(todo);

        // Assert
        final savedTodo = await todoHiveStore.getTodo('test-id-null');
        expect(savedTodo, isNotNull);
        expect(savedTodo!.description, isNull);
      });
    });

    group('updateTodo()', () {
      test('should update existing todo', () async {
        // Arrange
        const originalTodo = Todo(
          id: 'update-test',
          title: 'Original',
          description: 'Original Description',
          isCompleted: false,
        );
        const updatedTodo = Todo(
          id: 'update-test',
          title: 'Updated',
          description: 'Updated Description',
          isCompleted: true,
        );

        await todoHiveStore.saveTodo(originalTodo);

        // Act
        await todoHiveStore.updateTodo(updatedTodo);

        // Assert
        final result = await todoHiveStore.getTodo('update-test');
        expect(result!.title, 'Updated');
        expect(result.description, 'Updated Description');
        expect(result.isCompleted, true);
      });

      test('should create new todo if ID does not exist', () async {
        // Arrange
        const newTodo = Todo(
          id: 'new-todo',
          title: 'New Todo',
          description: 'New Description',
        );

        // Act
        await todoHiveStore.updateTodo(newTodo);

        // Assert
        final savedTodo = await todoHiveStore.getTodo('new-todo');
        expect(savedTodo, isNotNull);
        expect(savedTodo!.title, 'New Todo');
      });
    });

    group('getTodo()', () {
      test('should retrieve existing todo by ID', () async {
        // Arrange
        const todo = Todo(
          id: 'get-test',
          title: 'Get Test Todo',
          description: 'Description for get test',
          isCompleted: true,
        );
        await todoHiveStore.saveTodo(todo);

        // Act
        final result = await todoHiveStore.getTodo('get-test');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 'get-test');
        expect(result.title, 'Get Test Todo');
        expect(result.description, 'Description for get test');
        expect(result.isCompleted, true);
      });

      test('should return null for non-existent ID', () async {
        // Act
        final result = await todoHiveStore.getTodo('non-existent');

        // Assert
        expect(result, isNull);
      });
    });

    group('getAllTodos()', () {
      test('should return empty list when no todos exist', () {
        // Act
        final todos = todoHiveStore.getAllTodos();

        // Assert
        expect(todos, isEmpty);
      });

      test('should return all saved todos', () async {
        // Arrange
        const todo1 = Todo(id: '1', title: 'Todo 1', description: 'First todo');
        const todo2 = Todo(id: '2', title: 'Todo 2', description: 'Second todo');
        const todo3 = Todo(id: '3', title: 'Todo 3', description: null, isCompleted: true);

        await todoHiveStore.saveTodo(todo1);
        await todoHiveStore.saveTodo(todo2);
        await todoHiveStore.saveTodo(todo3);

        // Act
        final todos = todoHiveStore.getAllTodos();

        // Assert
        expect(todos.length, 3);
        expect(todos.map((t) => t.id), containsAll(['1', '2', '3']));
        
        final completedTodo = todos.firstWhere((t) => t.id == '3');
        expect(completedTodo.isCompleted, true);
        expect(completedTodo.description, isNull);
      });
    });

    group('deleteTodo()', () {
      test('should delete existing todo', () async {
        // Arrange
        const todo1 = Todo(id: 'delete-me', title: 'Delete Me', description: 'To be deleted');
        const todo2 = Todo(id: 'keep-me', title: 'Keep Me', description: 'To be kept');

        await todoHiveStore.saveTodo(todo1);
        await todoHiveStore.saveTodo(todo2);

        // Act
        await todoHiveStore.deleteTodo('delete-me');

        // Assert
        final deletedTodo = await todoHiveStore.getTodo('delete-me');
        final keptTodo = await todoHiveStore.getTodo('keep-me');
        
        expect(deletedTodo, isNull);
        expect(keptTodo, isNotNull);
        
        final allTodos = todoHiveStore.getAllTodos();
        expect(allTodos.length, 1);
        expect(allTodos.first.id, 'keep-me');
      });

      test('should handle deleting non-existent todo gracefully', () async {
        // Arrange
        const todo = Todo(id: 'existing', title: 'Existing Todo', description: 'Exists');
        await todoHiveStore.saveTodo(todo);

        // Act & Assert - should not throw
        await todoHiveStore.deleteTodo('non-existent');
        
        final allTodos = todoHiveStore.getAllTodos();
        expect(allTodos.length, 1); // Original todo should still exist
        expect(allTodos.first.id, 'existing');
      });

      test('should delete from empty store gracefully', () async {
        // Act & Assert - should not throw
        await todoHiveStore.deleteTodo('any-id');
        
        final allTodos = todoHiveStore.getAllTodos();
        expect(allTodos.length, 0);
      });
    });

    group('Edge Cases', () {
      test('should handle todos with special characters in title and description', () async {
        // Arrange
        const todo = Todo(
          id: 'special-chars',
          title: 'Todo with émojis 🚀 and spéciäl chars!',
          description: 'Description with newlines\nand\ttabs and 中文字符',
        );

        // Act
        await todoHiveStore.saveTodo(todo);
        final retrieved = await todoHiveStore.getTodo('special-chars');

        // Assert
        expect(retrieved!.title, 'Todo with émojis 🚀 and spéciäl chars!');
        expect(retrieved.description, 'Description with newlines\nand\ttabs and 中文字符');
      });

      test('should handle very long strings', () async {
        // Arrange
        final longTitle = 'A' * 1000;
        final longDescription = 'B' * 5000;
        final todo = Todo(
          id: 'long-strings',
          title: longTitle,
          description: longDescription,
        );

        // Act
        await todoHiveStore.saveTodo(todo);
        final retrieved = await todoHiveStore.getTodo('long-strings');

        // Assert
        expect(retrieved!.title, longTitle);
        expect(retrieved.description, longDescription);
      });

      test('should handle empty strings', () async {
        // Arrange
        const todo = Todo(
          id: 'empty-strings',
          title: '',
          description: '',
        );

        // Act
        await todoHiveStore.saveTodo(todo);
        final retrieved = await todoHiveStore.getTodo('empty-strings');

        // Assert
        expect(retrieved!.title, '');
        expect(retrieved.description, '');
      });
    });

    group('Performance Tests', () {
      test('should handle multiple todos efficiently', () async {
        // Arrange
        const numberOfTodos = 100; // Reduced for faster test execution
        final stopwatch = Stopwatch()..start();

        // Act - Save many todos
        for (int i = 0; i < numberOfTodos; i++) {
          final todo = Todo(
            id: 'todo-$i',
            title: 'Todo $i',
            description: 'Description for todo $i',
            isCompleted: i % 2 == 0,
          );
          await todoHiveStore.saveTodo(todo);
        }

        final saveTime = stopwatch.elapsedMilliseconds;
        stopwatch.reset();

        // Retrieve all todos
        final todos = todoHiveStore.getAllTodos();
        final retrieveTime = stopwatch.elapsedMilliseconds;

        stopwatch.stop();

        // Assert
        expect(todos.length, numberOfTodos);
        expect(saveTime, lessThan(5000)); // Should save 100 todos in less than 5 seconds
        expect(retrieveTime, lessThan(1000)); // Should retrieve 100 todos in less than 1 second
        
        // Verify data integrity
        expect(todos.any((t) => t.id == 'todo-0'), isTrue);
        expect(todos.any((t) => t.id == 'todo-${numberOfTodos - 1}'), isTrue);
      });
    });

    group('Data Integrity', () {
      test('should maintain todo properties correctly', () async {
        // Arrange
        const todo = Todo(
          id: 'integrity-test',
          title: 'Integrity Test Todo',
          description: 'Testing data integrity',
          isCompleted: true,
        );

        // Act
        await todoHiveStore.saveTodo(todo);
        final retrieved = await todoHiveStore.getTodo('integrity-test');

        // Assert - verify all properties are preserved
        expect(retrieved, isNotNull);
        expect(retrieved!.id, todo.id);
        expect(retrieved.title, todo.title);
        expect(retrieved.description, todo.description);
        expect(retrieved.isCompleted, todo.isCompleted);
      });

      test('should handle boolean states correctly', () async {
        // Arrange
        const completedTodo = Todo(
          id: 'completed',
          title: 'Completed Todo',
          description: 'A completed todo',
          isCompleted: true,
        );
        const incompleteTodo = Todo(
          id: 'incomplete',
          title: 'Incomplete Todo',
          description: 'An incomplete todo',
          isCompleted: false,
        );

        // Act
        await todoHiveStore.saveTodo(completedTodo);
        await todoHiveStore.saveTodo(incompleteTodo);

        // Assert
        final completed = await todoHiveStore.getTodo('completed');
        final incomplete = await todoHiveStore.getTodo('incomplete');

        expect(completed!.isCompleted, isTrue);
        expect(incomplete!.isCompleted, isFalse);
      });
    });
  });
}
