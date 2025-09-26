part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;
  const AddTodo({
    required this.title,
    this.description,
    required this.priority,
    this.dueDate,
  });

  @override
  List<Object?> get props => [title, description, priority, dueDate];
}

class UpdateTodo extends TodoEvent {
  final TodoEntity todo;
  final bool fromAddTodoScreen;
  const UpdateTodo(this.todo, this.fromAddTodoScreen);

  @override
  List<Object?> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final String id; // assuming id is String
  const DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTodoEvent extends TodoEvent {
  final TodoEntity todo;
  final List<TodoEntity> associatedTasks;
  final bool isCompleted;
  const ToggleTodoEvent(this.todo, this.associatedTasks, this.isCompleted);
}
