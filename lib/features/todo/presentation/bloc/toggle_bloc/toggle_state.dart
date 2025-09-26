part of 'toggle_bloc.dart';

sealed class ToggleState extends Equatable {
  const ToggleState();

  @override
  List<Object?> get props => [];
}

class ToggleInitial extends ToggleState {
  const ToggleInitial();
  @override
  List<Object?> get props => [];
}

class ToggleUpdated extends ToggleState {
  final TodoEntity todo;
  final List<TodoEntity> updatedList;
  final FilterOptions filter;
  const ToggleUpdated(this.todo, this.updatedList, this.filter);
  @override
  List<Object?> get props => [todo, updatedList, filter];
}

class ToggleError extends ToggleState {
  final String message;
  const ToggleError(this.message);
  @override
  List<Object?> get props => [message];
}
