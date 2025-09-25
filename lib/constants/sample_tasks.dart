import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';

final List<TodoEntity> sampleTodos = [
  TodoEntity(
    id: '1',
    title: "Buy groceries",
    description: "Milk, eggs, bread, and fruits",
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isCompleted: false,
    priority: TaskPriority.high,
    dueDate: DateTime.now().add(const Duration(days: 1)),
  ),
  TodoEntity(
    id: '2',
    title: "Finish Flutter assignment",
    description: "Complete EB Pearls technical task",
    createdAt: DateTime.now(),
    isCompleted: false,
    priority: TaskPriority.high,
    dueDate: DateTime.now().add(const Duration(days: 2)),
  ),
  TodoEntity(
    id: '3',
    title: "Workout",
    description: "1-hour gym session",
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    isCompleted: true,
    priority: TaskPriority.medium,
    dueDate: null,
  ),
  TodoEntity(
    id: '4',
    title: "Call Mom",
    description: "Catch up over the phone",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isCompleted: false,
    priority: TaskPriority.low,
    dueDate: null,
  ),
  TodoEntity(
    id: '5',
    title: "Team meeting",
    description: "Discuss project updates",
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    isCompleted: true,
    priority: TaskPriority.high,
    dueDate: DateTime.now(),
  ),
  TodoEntity(
    id: '6',
    title: "Read a book",
    description: "Continue reading 'Clean Code'",
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    isCompleted: false,
    priority: TaskPriority.low,
    dueDate: DateTime.now().add(const Duration(days: 5)),
  ),
];
