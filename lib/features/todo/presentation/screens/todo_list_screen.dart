import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/constants/sample_tasks.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/core/utils/ui_helper.dart';
import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
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
      body: Column(
        children: [
          BlocConsumer<TodoBloc, TodoState>(
            listener: (context, state) async {
              if (state is ToggleCompletion) {
                BlocProvider.of<TodoBloc>(context).add(UpdateTodo(state.todo));
              }
              if (state is TodoRemoved) {
                BlocProvider.of<TodoBloc>(context).add(LoadTodos());
              }
              if (state is TodoUpdated || state is TodoAdded) {
                await Future.delayed(Duration(seconds: 1));
                BlocProvider.of<TodoBloc>(context).add(LoadTodos());
              }
              if (state is TodoError) {
                UiHelper.showErrorFlashBar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is TodoLoaded) {
                todoList = state.todos;
              }
              return SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    var todo = sampleTodos[index];
                    return Container(
                      width: 1.sw,
                      height: 80.h,
                      padding: EdgeInsets.all(8.w),
                      margin: EdgeInsets.symmetric(
                        horizontal: 13.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: todo.isCompleted,
                            onChanged: (value) {
                              if (value != null) {
                                BlocProvider.of<TodoBloc>(
                                  context,
                                ).add(ToggleTodoEvent(todo.id, value));
                              }
                            },
                          ),
                          Container(
                            color: todo.priority.color,
                            width: 4.w,
                            height: 70.h,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          todo.title,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                decoration: todo.isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (todo.description != null)
                                    Expanded(
                                      child: Text(
                                        todo.description!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium?.copyWith(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                todo.priority.name.toUpperCase(),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: todo.priority.color),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      builder: (context) => Container(
                                        padding: const EdgeInsets.all(16),
                                        height: 150.h,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                width: 70.w,
                                                height: 2.h,
                                                color: sl<LightTheme>()
                                                    .secondaryColor,
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.edit),
                                              title: Text(
                                                "Edit Task",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          BuildContext context,
                                                        ) => AddTodoScreen(
                                                          todo: todo,
                                                        ),
                                                  ),
                                                );
                                                // handle edit
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.delete),
                                              title: Text(
                                                "Delete Task",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                              ),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text(
                                                      "Delete Task",
                                                    ),
                                                    content: const Text(
                                                      "Are you sure you want to delete this task?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          "Cancel",
                                                        ),
                                                      ),

                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              sl<LightTheme>()
                                                                  .highPriority,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                            true,
                                                          );
                                                          BlocProvider.of<
                                                                TodoBloc
                                                              >(context)
                                                              .add(
                                                                DeleteTodo(
                                                                  todo.id,
                                                                ),
                                                              );
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            color:
                                                                sl<LightTheme>()
                                                                    .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                // handle delete
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.more_vert),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // child: Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Text(
                //         'Add your very first todo',
                //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //           fontWeight: FontWeight.w300,
                //           color: sl<LightTheme>().secondaryColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 75.h,
        width: 75.w,
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
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
