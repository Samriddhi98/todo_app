import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/features/todo/presentation/screens/add_todo_screen.dart';
import 'package:todo_app/injection_container.dart';

class AddTodoButton extends StatelessWidget {
  const AddTodoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 60.w,
      child: FloatingActionButton(
        key: ValueKey('add-todo-button'),
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
    );
  }
}
