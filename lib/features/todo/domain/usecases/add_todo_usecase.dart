import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class AddTodoUsecase implements UseCase<bool, AddTodoParams> {
  final TodoRepository todoRepository;

  AddTodoUsecase({required this.todoRepository});

  @override
  Future<Either<Failure, bool>> call(AddTodoParams params) async {
    return await todoRepository.addTask(params.todo);
  }
}

class AddTodoParams {
  final TodoEntity todo;
  AddTodoParams(this.todo);
}
