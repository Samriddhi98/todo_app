import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:todo_app/core/error/exceptions.dart';
import 'package:todo_app/features/todo/data/models/todo_hive_model.dart';

abstract class TodoLocalDataSource {
  List<TodoHiveModel> getTasks();
  Future<void> addTask(TodoHiveModel task);
  Future<void> updateTask(TodoHiveModel task);
  Future<void> deleteTask(String id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<TodoHiveModel> box;
  TodoLocalDataSourceImpl({required this.box});

  @override
  Future<void> addTask(TodoHiveModel task) async {
    try {
      await box.put(task.id, task);
    } catch (e) {
      log('write exception $e');
      throw WriteException();
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      log('write exception $e');
      throw DeleteException();
    }
  }

  @override
  List<TodoHiveModel> getTasks() {
    try {
      final todos = box.values.toList();
      return todos;
    } catch (e) {
      log('read exception $e');
      throw ReadException();
    }
  }

  @override
  Future<void> updateTask(TodoHiveModel task) async {
    try {
      await task.save();
    } catch (e) {
      log('update exception $e');
      throw UpdateException();
    }
  }
}
