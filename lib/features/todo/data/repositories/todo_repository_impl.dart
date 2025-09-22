import 'package:dartz/dartz.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource todoLocalDataSource;
  TodoRepositoryImpl(this.todoLocalDataSource);

  @override
  Future<Either<Failure, bool>> addTask(TodoEntity todo) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getTasksList() {
    // TODO: implement getTasksList
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateTask(TodoEntity todo) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
