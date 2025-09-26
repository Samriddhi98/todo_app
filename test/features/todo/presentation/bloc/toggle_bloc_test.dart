import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/features/todo/domain/entities/enum/filter_options.dart';
import 'package:todo_app/features/todo/domain/entities/enum/task_priority.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo_usecase.dart';
import 'package:todo_app/features/todo/presentation/bloc/toggle_bloc/toggle_bloc.dart';

class MockUpdateTodoUsecase extends Mock implements UpdateTodoUsecase {}

class FakeUpdateTodoParams extends Fake implements UpdateTodoParams {}

void main() {
  late ToggleBloc toggleBloc;
  late MockUpdateTodoUsecase mockUpdateTodoUsecase;

  final tTodo = TodoEntity(
    id: '1',
    title: 'Test',
    description: 'desc',
    isCompleted: false,
    createdAt: DateTime.now(),
    priority: TaskPriority.high,
  );

  final tUpdatedTodo = tTodo.copyWith(isCompleted: true);

  setUpAll(() {
    registerFallbackValue(FakeUpdateTodoParams());
  });

  setUp(() {
    mockUpdateTodoUsecase = MockUpdateTodoUsecase();
    toggleBloc = ToggleBloc(updateTodo: mockUpdateTodoUsecase);
  });

  group('ToggleBloc Test', () {
    test('initial state should be ToggleInitial()', () {
      expect(toggleBloc.state, equals(ToggleInitial()));
    });

    test('should call UpdateTodoUsecase when event is added', () async {
      // Arrange
      when(
        () => mockUpdateTodoUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      toggleBloc.add(
        ToggleIsCompleteEvent(tTodo, [tTodo], true, FilterOptions.all),
      );

      await untilCalled(() => mockUpdateTodoUsecase.call(any()));

      // Assert
      verify(() => mockUpdateTodoUsecase.call(any())).called(1);
    });

    test('should emit [ToggleUpdated] when update succeeds', () async {
      // Arrange
      when(
        () => mockUpdateTodoUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));

      final expected = [
        ToggleUpdated(tUpdatedTodo, [tUpdatedTodo], FilterOptions.all),
      ];

      expectLater(toggleBloc.stream, emitsInOrder(expected));

      // Act
      toggleBloc.add(
        ToggleIsCompleteEvent(tTodo, [tTodo], true, FilterOptions.all),
      );
    });

    test('should emit [ToggleError] when update fails', () async {
      // Arrange
      when(
        () => mockUpdateTodoUsecase.call(any()),
      ).thenAnswer((_) async => Left(UpdateFailure()));

      final expected = [ToggleError("Failed to update todo")];

      expectLater(toggleBloc.stream, emitsInOrder(expected));

      // Act
      toggleBloc.add(
        ToggleIsCompleteEvent(tTodo, [tTodo], true, FilterOptions.all),
      );
    });
  });
}
