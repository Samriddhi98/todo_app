import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class RemoveTodoUsecase implements UseCase<bool, RemoveTodoParams> {
  final TodoRepository todoRepository;

  RemoveTodoUsecase({required this.todoRepository});

  @override
  Future<Either<Failure, bool>> call(RemoveTodoParams params) {
    return todoRepository.deleteTask(params.id);
  }
}

class RemoveTodoParams {
  final String id; // or int, depending on your TodoEntity
  RemoveTodoParams(this.id);
}
