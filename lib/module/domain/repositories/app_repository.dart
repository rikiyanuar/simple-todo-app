import '../../external/libraries/dartz.dart';
import '../entity/failure.dart';
import '../entity/todo_entity.dart';

abstract class AppRepository {
  Future<Either<Failure, List<TodoEntity>>> getAll();

  Future<Either<Failure, bool>> insertTodo(TodoEntity params);

  Future<Either<Failure, bool>> doneTodo(TodoEntity params);
}
