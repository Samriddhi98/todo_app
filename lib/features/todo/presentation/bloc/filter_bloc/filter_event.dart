part of 'filter_bloc.dart';

sealed class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class ChangeFilterEvent extends FilterEvent {
  final FilterOptions filter;

  const ChangeFilterEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class ApplyFilterEvent extends FilterEvent {
  final List<TodoEntity> todoList;
  final FilterOptions filter;

  const ApplyFilterEvent({required this.filter, required this.todoList});

  @override
  List<Object?> get props => [filter, todoList];
}
