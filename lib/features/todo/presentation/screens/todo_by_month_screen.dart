import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/features/todo/domain/entities/enum/filter_options.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/filter_bloc/filter_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/toggle_bloc/toggle_bloc.dart';
import 'package:todo_app/features/todo/presentation/widgets/filter_options_widget.dart';
import 'package:todo_app/features/todo/presentation/widgets/todo_loaded_section.dart';

class TodosByMonthView extends StatefulWidget {
  final int months;
  final List<TodoEntity> todoList;
  const TodosByMonthView({
    super.key,
    required this.months,
    required this.todoList,
  });

  @override
  State<TodosByMonthView> createState() => _TodosByMonthViewState();
}

class _TodosByMonthViewState extends State<TodosByMonthView> {
  late final PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    BlocProvider.of<FilterBloc>(
      context,
    ).add(ChangeFilterEvent(filter: FilterOptions.all));
  }

  void _nextPage() {
    if (_currentIndex < widget.months - 1) {
      setState(() => _currentIndex++);

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoLoaded) {
          final month = state.groupedTodos.keys.elementAt(_currentIndex);
          final todosForMonth = state.groupedTodos[month];
          if (todosForMonth == null || todosForMonth.isEmpty) {
            BlocProvider.of<FilterBloc>(context).add(
              ApplyFilterEvent(
                filter: BlocProvider.of<FilterBloc>(context).currentFilter,
                todoList: todosForMonth!,
              ),
            );
          }
        }
      },
      child: Container(
        height: 1.sh,
        width: 1.sw,
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            // Top bar with month name + navigation
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 20,
                  onPressed: _previousPage,
                ),
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoUpdated || state is TodoAdded) {
                      _currentIndex = 0;
                    }
                    if (state is TodoLoaded) {
                      var months = state.groupedTodos.keys.toList();
                      if (_currentIndex >= months.length) {
                        _currentIndex = months.length - 1;
                      }
                      return Text(
                        DateFormat('MMM yyyy').format(
                          DateFormat('yyyy-MM').parse(months[_currentIndex]),
                        ),
                        style: Theme.of(context).textTheme.labelLarge,
                      );
                    } else {
                      return Text(
                        DateFormat.yMMM().format(DateTime.now()),
                        style: Theme.of(context).textTheme.labelLarge,
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  iconSize: 20,
                  onPressed: _nextPage,
                ),
              ],
            ),
            FilterOptionWidget(),
            // PageView for month-based tasks
            Expanded(
              child: BlocConsumer<TodoBloc, TodoState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is TodoLoaded) {
                    return PageView.builder(
                      onPageChanged: (_) {
                        BlocProvider.of<FilterBloc>(
                          context,
                        ).add(ChangeFilterEvent(filter: FilterOptions.all));
                      },
                      controller: _pageController,
                      physics:
                          const NeverScrollableScrollPhysics(), // disable swipe
                      itemCount: state.groupedTodos.keys.length,
                      itemBuilder: (context, index) {
                        final month = state.groupedTodos.keys.elementAt(index);
                        final todosForMonth = state.groupedTodos[month];
                        if (todosForMonth == null || todosForMonth.isEmpty) {
                          return Center(
                            child: Text('No todos added for this month yet'),
                          );
                        } else {
                          return BlocListener<ToggleBloc, ToggleState>(
                            listener: (context, toggleState) {
                              if (toggleState is ToggleUpdated) {
                                BlocProvider.of<FilterBloc>(context).add(
                                  ApplyFilterEvent(
                                    filter: toggleState.filter,
                                    todoList: toggleState.updatedList,
                                  ),
                                );
                              }
                            },
                            child: BlocConsumer<FilterBloc, FilterState>(
                              listener: (context, filterState) async {
                                if (filterState is FilterChangedState) {
                                  BlocProvider.of<FilterBloc>(context).add(
                                    ApplyFilterEvent(
                                      filter: filterState.filter,
                                      todoList: todosForMonth,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is FilterApplied) {
                                  return TodoLoadedSection(
                                    todoList: todosForMonth,
                                    month: month,
                                    filteredList: state.todoList,
                                    appliedFilter: state.filter,
                                  );
                                } else if (state is FilterLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          );
                        }
                      },
                    );
                  } else if (state is TodoLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TodoEmpty) {
                    return Center(child: Text('No todos available'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
