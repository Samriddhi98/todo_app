import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/todo/domain/entities/enum/filter_options.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    on<ApplyFilterEvent>(_onApplyFilter);
  }

  FutureOr<void> _onApplyFilter(
    ApplyFilterEvent event,
    Emitter<FilterState> emit,
  ) {
    if (event.filter == FilterOptions.all) {
      emit(FilterApplied(filter: event.filter, todoList: event.todoList));
    } else if (event.filter == FilterOptions.completed) {
      final completedTodos = event.todoList
          .where((todo) => todo.isCompleted)
          .toList();
      emit(FilterApplied(filter: event.filter, todoList: completedTodos));
    } else if (event.filter == FilterOptions.notCompleted) {
      final notCompletedTodos = event.todoList
          .where((todo) => !todo.isCompleted)
          .toList();
      emit(FilterApplied(filter: event.filter, todoList: notCompletedTodos));
    }
  }
}
