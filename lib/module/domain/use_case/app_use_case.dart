import '../../external/libraries/dartz.dart';
import '../entity/failure.dart';
import '../entity/todo_entity.dart';
import '../repositories/app_repository.dart';
import 'done_todo_use_case.dart';
import 'get_all_use_case.dart';
import 'insert_todo_use_case.dart';
import 'use_case.dart';

abstract class AppUseCase {
  Future<Either<Failure, List<TodoEntity>>> getAll();

  Future<Either<Failure, bool>> insertTodo(TodoEntity params);

  Future<Either<Failure, bool>> doneTodo(TodoEntity params);
}

class AppUseCaseImpl extends AppUseCase {
  final AppRepository repository;

  AppUseCaseImpl({required this.repository});

  @override
  Future<Either<Failure, List<TodoEntity>>> getAll() {
    final response = GetAllUseCase(repository: repository);

    return response(NoParams());
  }

  @override
  Future<Either<Failure, bool>> insertTodo(TodoEntity params) {
    final response = InsertTodoUseCase(repository: repository);

    return response(params);
  }

  @override
  Future<Either<Failure, bool>> doneTodo(TodoEntity params) {
    final response = DoneTodoUseCase(repository: repository);

    return response(params);
  }
}
