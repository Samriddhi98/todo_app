// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoHiveModelAdapter extends TypeAdapter<TodoHiveModel> {
  @override
  final int typeId = 1;

  @override
  TodoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      isCompleted: fields[4] as bool,
      priority: fields[5] as TaskPriorityHive,
      dueDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.dueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityHiveAdapter extends TypeAdapter<TaskPriorityHive> {
  @override
  final int typeId = 2;

  @override
  TaskPriorityHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriorityHive.high;
      case 1:
        return TaskPriorityHive.medium;
      case 2:
        return TaskPriorityHive.low;
      default:
        return TaskPriorityHive.high;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriorityHive obj) {
    switch (obj) {
      case TaskPriorityHive.high:
        writer.writeByte(0);
        break;
      case TaskPriorityHive.medium:
        writer.writeByte(1);
        break;
      case TaskPriorityHive.low:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
