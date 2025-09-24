import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/widgets/app_text_button.dart';
import 'package:todo_app/features/todo/presentation/widgets/custom_text_form_field.dart';
import 'package:todo_app/features/todo/presentation/widgets/due_date_picker.dart';
import 'package:todo_app/injection_container.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final ValueNotifier<TaskPriority?> _selectedPriority = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      'Add new Todo',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: sl<LightTheme>().secondaryColor),
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
                          contentPadding: EdgeInsets.only(bottom: 50, top: 10),
                          hintText: 'Description',
                          maxLines: 4,
                          maxChars: 200,
                        ),
                        SizedBox(height: 10.h),
                        DropdownButtonFormField2<TaskPriority>(
                          value: _selectedPriority.value,
                          dropdownStyleData: DropdownStyleData(
                            offset: const Offset(0, -5), // shift dropdown down
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
                                    style: TextStyle(color: priority.color),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _selectedPriority.value = value;
                          },
                          validator: (value) =>
                              value == null ? "Please select a priority" : null,
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
                        text: 'Add',
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
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      sl<TodoBloc>().add(
        AddTodo(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _selectedPriority.value!,
          dueDate: DateTime.tryParse(_dateController.text),
        ),
      );
    }
  }
}
