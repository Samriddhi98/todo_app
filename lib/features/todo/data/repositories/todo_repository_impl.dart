import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/exceptions.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource todoLocalDataSource;
  TodoRepositoryImpl(this.todoLocalDataSource);

  @override
  Future<Either<Failure, bool>> addTask(TodoEntity todo) async {
    try {
      await todoLocalDataSource.addTask(todo.toHiveModel());
      return Right(true);
    } on WriteException catch (e) {
      return Left(WriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) async {
    try {
      await todoLocalDataSource.deleteTask(id);
      return Right(true);
    } on DeleteException catch (e) {
      return Left(DeleteFailure());
    }
  }

  @override
  Either<Failure, List<TodoEntity>> getTasksList() {
    try {
      final list = todoLocalDataSource.getTasks();
      List<TodoEntity> todos = [];
      for (var item in list) {
        todos.add(item.toEntity());
      }
      return Right(todos);
    } on ReadException catch (e) {
      return Left(DeleteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(TodoEntity todo) async {
    try {
      await todoLocalDataSource.updateTask(todo.toHiveModel());
      return Right(true);
    } on UpdateException catch (e) {
      return Left(UpdateFailure());
    }
  }
}
