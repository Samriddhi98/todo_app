import 'package:todo_app/features/todo/data/models/todo_hive_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoHiveModel>> getTasks();
  Future<void> addTask(TodoHiveModel task);
  Future<void> updateTask(TodoHiveModel task);
  Future<void> deleteTask(String id);
}
