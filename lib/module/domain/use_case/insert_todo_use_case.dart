import '../../external/libraries/dartz.dart';
import '../entity/failure.dart';
import '../entity/todo_entity.dart';
import '../repositories/app_repository.dart';
import 'use_case.dart';

class InsertTodoUseCase implements UseCase<bool, TodoEntity> {
  final AppRepository repository;

  InsertTodoUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(TodoEntity params) {
    return repository.insertTodo(params);
  }
}
