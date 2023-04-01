import 'package:flutter/material.dart';

import '../../domain/entity/todo_entity.dart';
import '../../domain/use_case/app_use_case.dart';
import '../../external/provider/app_provider.dart';
import 'general_state.dart';

class TodoListViewModel extends AppChangeNotifier {
  final AppUseCase useCase;
  List<TodoEntity>? todoList;
  final inputController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TodoListViewModel({required this.useCase});

  Future<GeneralState> getAll() async {
    try {
      isLoading = true;

      final state = await useCase.getAll();

      return state.fold(
        (l) => const GeneralState.clientError(),
        (data) {
          final active = data.where((el) => !el.isDone);
          final done = data.where((el) => el.isDone);
          todoList = [...active, ...done];

          return const GeneralState.success();
        },
      );
    } catch (e) {
      return const GeneralState.clientError();
    } finally {
      isLoading = false;
    }
  }

  Future<GeneralState> insertTodo() async {
    try {
      isLoading = true;

      final newId = DateTime.now().toIso8601String();

      final state = await useCase.insertTodo(TodoEntity.fromJson({
        "id": newId,
        "todo": inputController.text,
        "isDone": false,
      }));

      return state.fold(
        (l) => const GeneralState.clientError(),
        (r) => const GeneralState.success(),
      );
    } catch (e) {
      return const GeneralState.clientError();
    } finally {
      isLoading = false;
    }
  }

  Future<GeneralState> doneTodo(TodoEntity data) async {
    try {
      isLoading = true;

      final state = await useCase.doneTodo(data);

      return state.fold(
        (l) => const GeneralState.clientError(),
        (r) => const GeneralState.success(),
      );
    } catch (e) {
      return const GeneralState.clientError();
    } finally {
      isLoading = false;
    }
  }
}
