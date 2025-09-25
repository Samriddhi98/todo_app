import 'package:equatable/equatable.dart';
import 'package:todo_app/features/todo/data/models/todo_hive_model.dart';

import 'enum/task_priority.dart';

class TodoEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final bool isCompleted;
  final TaskPriority priority;
  final DateTime? dueDate;

  const TodoEntity({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.isCompleted,
    required this.priority,
    this.dueDate,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdAt,
    isCompleted,
    priority,
    dueDate,
  ];

  TodoEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? dueDate,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  TodoHiveModel toHiveModel() => TodoHiveModel(
    id: id,
    title: title,
    priority: mapPriorityEntityToHive(priority),
    dueDate: dueDate,
    isCompleted: isCompleted,
    createdAt: createdAt,
    description: description,
  );

  factory TodoEntity.fromHive(TodoHiveModel model) => TodoEntity(
    id: model.id,
    title: model.title,
    description: model.description,
    priority: model.priority.mapPriorityHiveToEntity(),
    dueDate: model.dueDate,
    isCompleted: model.isCompleted,
    createdAt: model.createdAt,
  );

  TaskPriorityHive mapPriorityEntityToHive(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return TaskPriorityHive.low;
      case TaskPriority.medium:
        return TaskPriorityHive.medium;
      case TaskPriority.high:
        return TaskPriorityHive.high;
    }
  }
}
