import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';

abstract class TodoRepository {
  Either<Failure, List<TodoEntity>> getTasksList();
  Future<Either<Failure, bool>> addTask(TodoEntity todo);
  Future<Either<Failure, bool>> updateTask(TodoEntity todo);
  Future<Either<Failure, bool>> deleteTask(String id);
}
