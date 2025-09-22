import 'package:todo_app/features/todo/data/models/todo_hive_model.dart';

enum TaskPriority { high, medium, low }

extension TaskPriorityExtension on TaskPriority {
  TaskPriorityHive mapPriorityEntityToHive() {
    switch (this) {
      case TaskPriority.low:
        return TaskPriorityHive.low;
      case TaskPriority.medium:
        return TaskPriorityHive.medium;
      case TaskPriority.high:
        return TaskPriorityHive.high;
    }
  }
}
