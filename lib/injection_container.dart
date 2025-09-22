import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_app/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todo_list_usecase.dart';
import 'package:todo_app/features/todo/domain/usecases/remove_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo_usecase.dart';

import 'features/todo/data/datasources/todo_local_data_source.dart';
import 'features/todo/data/models/todo_hive_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// bloc
  /// Usecases
  sl.registerLazySingleton<GetTodoListUsecase>(
    () => GetTodoListUsecase(todoRepository: sl()),
  );

  sl.registerLazySingleton<AddTodoUsecase>(
    () => AddTodoUsecase(todoRepository: sl()),
  );

  sl.registerLazySingleton<RemoveTodoUsecase>(
    () => RemoveTodoUsecase(todoRepository: sl()),
  );

  sl.registerLazySingleton<UpdateTodoUsecase>(
    () => UpdateTodoUsecase(todoRepository: sl()),
  );

  /// Repository
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  /// Data source
  final todoBox = await Hive.openBox<TodoHiveModel>('todos');

  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(box: todoBox),
  );

  /// External

  sl.registerLazySingleton(() => LightTheme());
}
