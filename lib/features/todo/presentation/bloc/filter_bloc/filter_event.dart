part of 'filter_bloc.dart';

sealed class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class ApplyFilterEvent extends FilterEvent {
  final FilterOptions filter;
  final List<TodoEntity> todoList;

  const ApplyFilterEvent({required this.filter, required this.todoList});

  @override
  List<Object?> get props => [filter, todoList];
}
