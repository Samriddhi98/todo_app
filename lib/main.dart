import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/injection_container.dart';

import 'core/observer/app_bloc_observer.dart';
import 'core/theme/app_custom_theme.dart';
import 'features/todo/data/models/todo_hive_model.dart';
import 'features/todo/presentation/screens/todo_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoHiveModelAdapter());
  Hive.registerAdapter(TaskPriorityHiveAdapter());

  await init();
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<TodoBloc>())],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.baseTheme(),
          // theme: ThemeData(
          //
          //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // ),
          home: const MyHomePage(title: 'Todo App'),
        ),
      ),
    );
  }
}
