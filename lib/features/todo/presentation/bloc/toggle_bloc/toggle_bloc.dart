import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo_usecase.dart';

part 'toggle_event.dart';
part 'toggle_state.dart';

class ToggleBloc extends Bloc<ToggleEvent, ToggleState> {
  final UpdateTodoUsecase updateTodo;

  ToggleBloc({required this.updateTodo}) : super(ToggleInitial()) {
    on<ToggleIsCompleteEvent>(_onToggleTodoCompletion);
  }

  FutureOr<void> _onToggleTodoCompletion(
    ToggleIsCompleteEvent event,
    Emitter<ToggleState> emit,
  ) async {
    var todo = event.todo.copyWith(isCompleted: event.isCompleted);
    final result = await updateTodo(UpdateTodoParams(todo));
    result.fold((failure) => emit(ToggleError("Failed to update todo")), (_) {
      emit(ToggleUpdated(todo));
    });
  }
}
