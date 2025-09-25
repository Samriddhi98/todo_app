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
  const ToggleUpdated(this.todo);
  @override
  List<Object?> get props => [todo];
}

class ToggleError extends ToggleState {
  final String message;
  const ToggleError(this.message);
  @override
  List<Object?> get props => [message];
}
