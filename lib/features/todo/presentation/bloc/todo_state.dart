part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoAdded extends TodoState {}

class TodoUpdated extends TodoState {
  final bool pause;
  const TodoUpdated(this.pause);

  @override
  List<Object?> get props => [pause];
}

class TodoRemoved extends TodoState {}

class TodoEmpty extends TodoState {}

class ToggleCompletion extends TodoState {
  final TodoEntity todo;
  const ToggleCompletion(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;
  final Map<String, List<TodoEntity>> groupedTodos;
  const TodoLoaded(this.todos, this.groupedTodos);

  @override
  List<Object?> get props => [todos, groupedTodos];
}

class TodoError extends TodoState {
  final String message;
  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}
