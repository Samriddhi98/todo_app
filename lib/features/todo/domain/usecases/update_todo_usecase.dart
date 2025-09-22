import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class UpdateTodoUsecase implements UseCase<bool, UpdateTodoParams> {
  final TodoRepository todoRepository;

  UpdateTodoUsecase({required this.todoRepository});

  @override
  Future<Either<Failure, bool>> call(UpdateTodoParams params) {
    return todoRepository.updateTask(params.todo);
  }
}

class UpdateTodoParams {
  final TodoEntity todo;
  UpdateTodoParams(this.todo);
}
