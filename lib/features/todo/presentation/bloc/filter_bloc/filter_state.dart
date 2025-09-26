part of 'filter_bloc.dart';

sealed class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

class FilterInitial extends FilterState {}

class FilterChangedState extends FilterState {
  final FilterOptions filter;

  const FilterChangedState({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class FilterLoading extends FilterState {}

class FilterApplied extends FilterState {
  final FilterOptions filter;
  final List<TodoEntity> todoList;
  const FilterApplied({required this.filter, required this.todoList});

  @override
  List<Object?> get props => [filter, todoList];
}
