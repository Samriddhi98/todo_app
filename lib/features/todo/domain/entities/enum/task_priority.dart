import 'dart:ui';

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

  Color get color {
    switch (this) {
      case TaskPriority.high:
        return Color(0xffE7526E);
      case TaskPriority.medium:
        return Color(0xffF7C732);
      case TaskPriority.low:
        return Color(0xff17BD81);
    }
  }
}
