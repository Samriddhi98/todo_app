part of 'filter_bloc.dart';

sealed class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

class FilterInitial extends FilterState {}

class FilterApplied extends FilterState {
  final FilterOptions filter;
  final List<TodoEntity> todoList;
  const FilterApplied({required this.filter, required this.todoList});

  @override
  List<Object?> get props => [filter, todoList];
}
