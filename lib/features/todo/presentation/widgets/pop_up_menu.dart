import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/features/todo/domain/entities/enum/filter_options.dart';
import 'package:todo_app/features/todo/presentation/bloc/filter_bloc/filter_bloc.dart';
import 'package:todo_app/injection_container.dart';

class FilterOptionWidget extends StatefulWidget {
  const FilterOptionWidget({super.key});

  @override
  State<FilterOptionWidget> createState() => _FilterOptionWidgetState();
}

class _FilterOptionWidgetState extends State<FilterOptionWidget> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 40,
      child: Wrap(
        spacing: 8,
        children: FilterOptions.values.map((filter) {
          return BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              if (state is FilterApplied) {
                return ChoiceChip(
                  label: Text(filter.label),
                  disabledColor: Colors.blue,
                  backgroundColor: sl<LightTheme>().primaryColor,
                  selectedColor: sl<LightTheme>().quatenaryColor.withAlpha(200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.w),
                    side: BorderSide(color: sl<LightTheme>().quatenaryColor),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  pressElevation: 0,
                  labelStyle: TextStyle(
                    color: selectedFilter == filter.label
                        ? sl<LightTheme>().primaryColor
                        : sl<LightTheme>().quatenaryColor,
                    // 👈 change based on state
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                  showCheckmark: false,
                  selected: selectedFilter == filter.label,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = filter.label; // update selected filter
                    });
                  },
                );
              } else {
                return SizedBox();
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
