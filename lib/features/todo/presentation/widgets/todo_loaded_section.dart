import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/core/utils/debouncer.dart';
import 'package:todo_app/features/todo/domain/entities/enum/filter_options.dart';
import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/toggle_bloc/toggle_bloc.dart';
import 'package:todo_app/features/todo/presentation/screens/add_todo_screen.dart';
import 'package:todo_app/injection_container.dart';

class TodoLoadedSection extends StatefulWidget {
  const TodoLoadedSection({
    super.key,
    required this.filteredList,
    required this.todoList,
    required this.appliedFilter,
    required this.month,
  });

  final List<TodoEntity> filteredList;
  final List<TodoEntity> todoList;
  final FilterOptions appliedFilter;
  final String month;

  @override
  State<TodoLoadedSection> createState() => _TodoLoadedSectionState();
}

class _TodoLoadedSectionState extends State<TodoLoadedSection> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500); // 0.5s delay

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<ToggleBloc, ToggleState>(
          builder: (context, state) {
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                },
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.filteredList.length,
                  itemBuilder: (context, index) {
                    var todo = widget.filteredList[index];
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
                          BlocBuilder<ToggleBloc, ToggleState>(
                            builder: (context, state) {
                              if (state is ToggleUpdated) {
                                if (state.todo.id == todo.id) {
                                  todo = state.todo;
                                }
                              }
                              return Checkbox(
                                value: todo.isCompleted,
                                onChanged: (value) {
                                  if (value != null) {
                                    _debouncer.run(() {
                                      BlocProvider.of<ToggleBloc>(context).add(
                                        ToggleIsCompleteEvent(
                                          todo,
                                          widget.todoList,
                                          value,
                                          widget.appliedFilter,
                                        ),
                                      );
                                    });
                                  }
                                },
                              );
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
                                        child:
                                            BlocBuilder<
                                              ToggleBloc,
                                              ToggleState
                                            >(
                                              builder: (context, state) {
                                                var isCompleted =
                                                    todo.isCompleted;
                                                if (state is ToggleUpdated) {
                                                  isCompleted =
                                                      state.todo.isCompleted;
                                                }
                                                return Text(
                                                  todo.title,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        decoration:
                                                            todo.isCompleted
                                                            ? TextDecoration
                                                                  .lineThrough
                                                            : TextDecoration
                                                                  .none,
                                                      ),
                                                );
                                              },
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
              ),
            );
          },
        ),
      ],
    );
  }
}
