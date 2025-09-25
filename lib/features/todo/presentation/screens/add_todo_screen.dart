import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/widgets/app_text_button.dart';
import 'package:todo_app/features/todo/presentation/widgets/custom_text_form_field.dart';
import 'package:todo_app/features/todo/presentation/widgets/due_date_picker.dart';
import 'package:todo_app/injection_container.dart';

class AddTodoScreen extends StatefulWidget {
  final TodoEntity? todo;
  const AddTodoScreen({super.key, this.todo});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final ValueNotifier<TaskPriority?> _selectedPriority =
      ValueNotifier<TaskPriority?>(null);
  var title = 'Add new Todo';

  @override
  void initState() {
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description ?? '';
      _selectedPriority.value = widget.todo!.priority;
      if (widget.todo!.dueDate != null) {
        _dateController.text = widget.todo!.dueDate.toString();
      }
      title = 'Edit todo';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) async {
        if (state is TodoAdded) {
          _titleController.clear();
          _descriptionController.clear();
          _dateController.clear();
          _selectedPriority.value = null;
          await Future.delayed(Duration(seconds: 1));
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 1.sh,
                width: 1.sw,
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  top: 30.h,
                  bottom: 30.h,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back_ios, size: 24.sp),
                        ),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: sl<LightTheme>().secondaryColor,
                              ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ExpandingUnderlineTextField(
                              hintText: 'Title',
                              controller: _titleController,
                              maxChars: 30,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Title cannot be empty";
                                }
                                if (value.length < 3) {
                                  return "Title must be at least 3 characters long";
                                }
                                return null; // ✅ valid input
                              },
                            ),
                            ExpandingUnderlineTextField(
                              controller: _descriptionController,
                              contentPadding: EdgeInsets.only(
                                bottom: 50,
                                top: 10,
                              ),
                              hintText: 'Description',
                              maxLines: 4,
                              maxChars: 200,
                            ),
                            SizedBox(height: 10.h),
                            ValueListenableBuilder<TaskPriority?>(
                              valueListenable: _selectedPriority,
                              builder: (context, _, _) {
                                return DropdownButtonFormField2<TaskPriority>(
                                  value: _selectedPriority.value,
                                  dropdownStyleData: DropdownStyleData(
                                    offset: const Offset(
                                      0,
                                      -5,
                                    ), // shift dropdown down
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Select Priority',
                                    hintStyle: TextStyle(
                                      color: sl<LightTheme>().titleTextColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.w),
                                      ),
                                      borderSide: BorderSide(
                                        color: sl<LightTheme>().titleTextColor,
                                        width: 1.2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: sl<LightTheme>().quatenaryColor
                                            .withAlpha(100),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 2.w,
                                        color: sl<LightTheme>().quatenaryColor
                                            .withAlpha(100),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                  ),
                                  hint: const Text("Select Priority"),
                                  isExpanded: true, // makes it full-width
                                  items: TaskPriority.values.map((priority) {
                                    return DropdownMenuItem<TaskPriority>(
                                      value: priority,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: priority.color,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            priority.name.toUpperCase(),
                                            style: TextStyle(
                                              color: priority.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    _selectedPriority.value = value;
                                  },
                                  validator: (value) => value == null
                                      ? "Please select a priority"
                                      : null,
                                );
                              },
                            ),
                            SizedBox(height: 10.h),

                            DueDatePicker(dateController: _dateController),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextButton(
                            text: 'Cancel',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            textColor: sl<LightTheme>().quatenaryColor,
                            borderColor: sl<LightTheme>().quatenaryColor,
                            borderWidth: 1.5,
                            borderRadius: 12,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        Expanded(
                          child: AppTextButton(
                            text: widget.todo != null ? 'Edit' : 'Add',
                            onPressed: () {
                              _submitForm();
                            },
                            textColor: sl<LightTheme>().primaryColor,
                            borderColor: sl<LightTheme>().secondaryColor,
                            buttonColor: sl<LightTheme>().secondaryColor,
                            borderWidth: 1.5,
                            borderRadius: 12,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 2000),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    return _buildChild(state, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChild(TodoState state, BuildContext context) {
    if (state is TodoLoading) {
      return Container(
        key: ValueKey("loading"),
        height: 1.sh,
        width: 1.sw,
        color: sl<LightTheme>().primaryColor.withAlpha(230),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(widget.todo != null ? 'Editing Todo' : 'Adding Todo'),
          ],
        ),
      );
    } else if (state is TodoAdded || state is TodoUpdated) {
      return Container(
        key: ValueKey("loading"),
        height: 1.sh,
        width: 1.sw,
        color: sl<LightTheme>().primaryColor.withAlpha(230),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              key: ValueKey("success"),
              color: Colors.green,
              size: 48,
            ),
            Text(
              widget.todo != null
                  ? 'Successfully updated'
                  : 'Successfully added',
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final todo = widget.todo;
      DateTime? parsedDate;
      if (_dateController.text.isNotEmpty) {
        parsedDate = DateFormat("dd MMM yyyy").parse(_dateController.text);
        log('parsed Date $parsedDate');
      }
      if (todo != null) {
        BlocProvider.of<TodoBloc>(context).add(
          UpdateTodo(
            todo.copyWith(
              title: _titleController.text,
              description: _descriptionController.text,
              priority: _selectedPriority.value!,
              dueDate: parsedDate,
            ),
            true,
          ),
        );
      } else {
        BlocProvider.of<TodoBloc>(context).add(
          AddTodo(
            title: _titleController.text,
            description: _descriptionController.text,
            priority: _selectedPriority.value!,
            dueDate: parsedDate,
          ),
        );
      }
    }
  }
}
