import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/screens/add_todo_screen.dart';
import 'package:todo_app/injection_container.dart';

import 'core/theme/app_custom_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/todo/data/models/todo_hive_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoHiveModelAdapter());
  await init();

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
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,

        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Add your very first todo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: sl<LightTheme>().secondaryColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 75.h,
        width: 75.w,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => AddTodoScreen(),
              ),
            );
          },
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: sl<LightTheme>().quatenaryColor,
            size: 40,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 16,
        color: sl<LightTheme>().quatenaryColor.withAlpha(100),
        height: 55.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.home,
                color: sl<LightTheme>().quatenaryColor,
                size: 40,
              ),
              Icon(
                Icons.settings,
                color: sl<LightTheme>().quatenaryColor,
                size: 40,
              ),
            ],
          ),
        ),
        //  child: Container(height: 30),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
