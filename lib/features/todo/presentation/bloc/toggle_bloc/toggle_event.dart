part of 'toggle_bloc.dart';

sealed class ToggleEvent extends Equatable {
  const ToggleEvent();

  @override
  List<Object?> get props => [];
}

class ToggleIsCompleteEvent extends ToggleEvent {
  final TodoEntity todo;
  final List<TodoEntity> associatedTasks;
  final bool isCompleted;
  const ToggleIsCompleteEvent(
    this.todo,
    this.associatedTasks,
    this.isCompleted,
  );
}
