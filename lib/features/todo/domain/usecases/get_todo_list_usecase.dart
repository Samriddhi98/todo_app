import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class GetTodoListUsecase implements UseCase<List<TodoEntity>, NoParams> {
  final TodoRepository todoRepository;

  GetTodoListUsecase({required this.todoRepository});
  @override
  Future<Either<Failure, List<TodoEntity>>> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
