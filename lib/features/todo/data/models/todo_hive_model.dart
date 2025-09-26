import 'package:hive/hive.dart';
import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';

part 'todo_hive_model.g.dart';

@HiveType(typeId: 1)
class TodoHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  TaskPriorityHive priority;

  @HiveField(6)
  DateTime? dueDate;

  TodoHiveModel({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.isCompleted,
    required this.priority,
    this.dueDate,
  });

  TodoEntity toEntity() => TodoEntity(
    id: id,
    title: title,
    description: description,
    priority: mapPriorityHiveToEntity(priority),
    dueDate: dueDate,
    isCompleted: isCompleted,
    createdAt: createdAt,
  );

  factory TodoHiveModel.fromEntity(TodoEntity entity) => TodoHiveModel(
    id: entity.id,
    title: entity.title,
    priority: entity.priority.mapPriorityEntityToHive(),
    dueDate: entity.dueDate,
    isCompleted: entity.isCompleted,
    createdAt: entity.createdAt,
  );

  TaskPriority mapPriorityHiveToEntity(TaskPriorityHive priority) {
    switch (priority) {
      case TaskPriorityHive.low:
        return TaskPriority.low;
      case TaskPriorityHive.medium:
        return TaskPriority.medium;
      case TaskPriorityHive.high:
        return TaskPriority.high;
    }
  }
}

@HiveType(typeId: 2)
enum TaskPriorityHive {
  @HiveField(0)
  high,

  @HiveField(1)
  medium,

  @HiveField(2)
  low,
}

extension TaskPriorityHiveExtension on TaskPriorityHive {
  TaskPriority mapPriorityHiveToEntity() {
    switch (this) {
      case TaskPriorityHive.low:
        return TaskPriority.low;
      case TaskPriorityHive.medium:
        return TaskPriority.medium;
      case TaskPriorityHive.high:
        return TaskPriority.high;
    }
  }
}
