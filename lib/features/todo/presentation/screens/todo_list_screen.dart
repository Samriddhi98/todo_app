import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/core/utils/ui_helper.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/screens/todo_by_month_screen.dart';
import 'package:todo_app/injection_container.dart';

import 'add_todo_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var todoList = <TodoEntity>[];

  @override
  void initState() {
    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.onPrimary,
      //
      //   title: Text(widget.title),
      // ),
      body: Container(
        child: Column(
          children: [
            BlocConsumer<TodoBloc, TodoState>(
              listener: (context, state) async {
                if (state is ToggleCompletion) {
                  BlocProvider.of<TodoBloc>(
                    context,
                  ).add(UpdateTodo(state.todo, false));
                }
                if (state is TodoRemoved) {
                  BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                }
                if (state is TodoUpdated) {
                  if (state.pause) {
                    await Future.delayed(Duration(seconds: 1));
                  }

                  if (context.mounted) {
                    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                  }
                }
                if (state is TodoAdded) {
                  await Future.delayed(Duration(seconds: 1));
                  if (context.mounted) {
                    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                  }
                }
                if (state is TodoError) {
                  if (context.mounted) {
                    UiHelper.showErrorFlashBar(context, state.message);
                  }
                }
              },
              builder: (context, state) {
                int months = 0;
                if (state is TodoLoaded) {
                  todoList = state.todos;
                  months = state.groupedTodos.keys.length;
                }
                return Container(
                  height: 1.sh,
                  width: 1.sw,
                  padding: EdgeInsets.only(top: 40.h, left: 8.w, right: 8.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(children: [Text('My Todo List')]),
                        Row(),
                        TodosByMonthView(months: months),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 60.h,
        width: 60.w,
        child: FloatingActionButton(
          backgroundColor: sl<LightTheme>().primaryColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => AddTodoScreen(),
              ),
            );
          },
          shape: CircleBorder(),
          child: Icon(
            Icons.edit_note,
            color: sl<LightTheme>().quatenaryColor,
            size: 40,
          ),
        ),
      ),
    );
  }
}
