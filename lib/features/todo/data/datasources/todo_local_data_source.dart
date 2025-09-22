import 'package:hive/hive.dart';
import 'package:todo_app/features/todo/data/models/todo_hive_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoHiveModel>> getTasks();
  Future<void> addTask(TodoHiveModel task);
  Future<void> updateTask(TodoHiveModel task);
  Future<void> deleteTask(String id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<TodoHiveModel> box;
  TodoLocalDataSourceImpl({required this.box});

  @override
  Future<void> addTask(TodoHiveModel task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TodoHiveModel>> getTasks() {
    // TODO: implement getTasks
    throw UnimplementedError();
  }

  @override
  Future<void> updateTask(TodoHiveModel task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
