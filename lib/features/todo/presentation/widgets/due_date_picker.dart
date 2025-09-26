import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/injection_container.dart';

class DueDatePicker extends StatefulWidget {
  final TextEditingController dateController;
  const DueDatePicker({super.key, required this.dateController});

  @override
  State<DueDatePicker> createState() => _DueDatePickerState();
}

class _DueDatePickerState extends State<DueDatePicker> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        widget.dateController.text = DateFormat("dd MMM yyyy").format(picked);
      });
    }
  }

  @override
  void initState() {
    if (widget.dateController.text.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.dateController.text);
      widget.dateController.text = DateFormat(
        "dd MMM yyyy",
      ).format(_selectedDate!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: sl<LightTheme>().titleTextColor),
      ),
      height: 100.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Due Date',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: sl<LightTheme>().titleTextColor,
            ),
          ),
          SizedBox(height: 5.h),
          TextFormField(
            readOnly: true,
            onTap: _pickDate,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: sl<LightTheme>().titleTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),

              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            onChanged: (value) {
              widget.dateController.text = value;
            },
            controller: widget.dateController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a due date';
              }
            },
          ),
        ],
      ),
    );
  }
}
