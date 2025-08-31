

import 'package:hive/hive.dart';
import 'package:weather_todo/domain/models/todo.dart';

class TodoAdopter extends TypeAdapter<Todo> {
  final int _tid;

  @override
  get typeId => _tid;

  TodoAdopter(this._tid);

  @override
  Todo read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final isCompleted = reader.readBool();
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description ?? '');
    writer.writeBool(obj.isCompleted);
  }
}