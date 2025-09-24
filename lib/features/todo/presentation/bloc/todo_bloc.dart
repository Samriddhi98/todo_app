import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final result = await getTodos.call(NoParams());
    result.fold(
      (failure) => emit(TodoError("Failed to load todos")),
      (todos) => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final todo = TodoEntity(
      id: generateTaskId(),
      title: event.title,
      createdAt: DateTime.now(),
      isCompleted: false,
      priority: event.priority,
    );
    final result = await addTodo(AddTodoParams(todo));
    result.fold((failure) => emit(TodoError("Failed to add todo")), (_) {
      emit(TodoAdded());
    });
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentTodos = List<TodoEntity>.from((state as TodoLoaded).todos);
      final index = currentTodos.indexWhere((t) => t.id == event.todo.id);
      if (index != -1) {
        final result = await updateTodo(UpdateTodoParams(event.todo));
        result.fold((failure) => emit(TodoError("Failed to update todo")), (_) {
          currentTodos[index] = event.todo;
          emit(TodoLoaded(currentTodos));
        });
      }
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentTodos = List<TodoEntity>.from((state as TodoLoaded).todos);
      final result = await removeTodo(RemoveTodoParams(event.id));
      result.fold((failure) => emit(TodoError("Failed to delete todo")), (_) {
        currentTodos.removeWhere((t) => t.id == event.id);
        emit(TodoLoaded(currentTodos));
      });
    }
  }
}
