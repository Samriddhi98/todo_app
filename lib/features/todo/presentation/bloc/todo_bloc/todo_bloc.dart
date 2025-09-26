import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/core/utils/id_generator.dart';
import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todo_list_usecase.dart';
import 'package:todo_app/features/todo/domain/usecases/remove_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final AddTodoUsecase addTodo;
  final UpdateTodoUsecase updateTodo;
  final RemoveTodoUsecase removeTodo;
  final GetTodoListUsecase getTodos;

  TodoBloc({
    required this.addTodo,
    required this.getTodos,
    required this.removeTodo,
    required this.updateTodo,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoEvent>(_onToggleTodoCompletion);
  }

  List<TodoEntity> todoList = [];
  Map<String, List<TodoEntity>> groupedByMonth = {};

  /// same grouping function but inside bloc (or in a helper file)
  Map<String, List<TodoEntity>> groupTodosByMonth(List<TodoEntity> todos) {
    final Map<String, List<TodoEntity>> grouped = {};

    if (todos.isEmpty) return grouped;

    final withDueDate = todos.where((t) => t.dueDate != null).toList();
    if (withDueDate.isEmpty) return grouped;

    withDueDate.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    final firstDate = DateTime(
      withDueDate.first.dueDate!.year,
      withDueDate.first.dueDate!.month,
    );
    final lastDate = DateTime(
      withDueDate.last.dueDate!.year,
      withDueDate.last.dueDate!.month,
    );

    DateTime current = firstDate;
    while (current.isBefore(lastDate.add(const Duration(days: 1)))) {
      final monthKey = DateFormat('yyyy-MM').format(current);
      grouped[monthKey] = [];
      current = DateTime(current.year, current.month + 1);
    }

    for (final todo in withDueDate) {
      final monthKey = DateFormat('yyyy-MM').format(todo.dueDate!);
      grouped[monthKey]!.add(todo);
    }

    return grouped;
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final result = await getTodos.call(NoParams());
    result.fold((failure) => emit(TodoError("Failed to load todos")), (todos) {
      if (todos.isEmpty) {
        emit(TodoEmpty());
      } else {
        todoList
          ..clear()
          ..addAll(todos);
        final grouped = groupTodosByMonth(todoList);
        groupedByMonth.addAll(grouped);
        emit(TodoLoaded(todoList, grouped));
      }
    });
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    await Future.delayed(const Duration(seconds: 2));

    final todo = TodoEntity(
      id: generateTaskId(),
      title: event.title,
      description: event.description,
      createdAt: DateTime.now(),
      dueDate: event.dueDate,
      isCompleted: false,
      priority: event.priority,
    );
    final result = await addTodo(AddTodoParams(todo));
    result.fold((failure) => emit(TodoError("Failed to add todo")), (_) {
      emit(TodoAdded());
    });
    // await Future.delayed(const Duration(seconds: 2));
    // emit(TodoInitial());
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (event.fromAddTodoScreen) {
      emit(TodoLoading());
      await Future.delayed(Duration(milliseconds: 500));
    }
    final index = todoList.indexWhere((t) => t.id == event.todo.id);
    // sampleTodos[index] = event.todo;
    // emit(TodoUpdated());

    if (index != -1) {
      final result = await updateTodo(UpdateTodoParams(event.todo));
      result.fold((failure) => emit(TodoError("Failed to update todo")), (_) {
        todoList[index] = event.todo;
        emit(TodoUpdated(event.fromAddTodoScreen));
      });
    } else {
      emit(TodoError("Failed to update todo"));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    // final index = sampleTodos.indexWhere((t) => t.id == event.id);
    // try {
    //   sampleTodos.removeAt(index);
    //   emit(TodoRemoved());
    // } catch (e) {
    //   emit(TodoError(e.toString()));
    // }

    final result = await removeTodo(RemoveTodoParams(event.id));
    result.fold((failure) => emit(TodoError("Failed to delete todo")), (_) {
      todoList.removeWhere((t) => t.id == event.id);
      emit(TodoRemoved());
    });
  }

  FutureOr<void> _onToggleTodoCompletion(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) {
    TodoEntity? updatedTodo;
    var todo = todoList.firstWhere((todo) {
      if (todo.id == event.todo.id) {
        return true;
      } else {
        return false;
      }
    });

    updatedTodo = todo.copyWith(isCompleted: event.isCompleted);
    emit(ToggleCompletion(updatedTodo!));
  }
}
