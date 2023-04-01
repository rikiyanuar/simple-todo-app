import '../../domain/entity/failure.dart';
import '../../domain/entity/todo_entity.dart';
import '../../domain/repositories/app_repository.dart';
import '../../external/libraries/dartz.dart';
import '../datasource/local/app_local_data_source.dart';

class AppRepositoryImpl extends AppRepository {
  final AppLocalDataSource localDataSource;

  AppRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<TodoEntity>>> getAll() async {
    try {
      final response = await localDataSource.getAll();

      return Right(response);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> insertTodo(TodoEntity params) async {
    try {
      final response = await localDataSource.insertTodo(params);

      return Right(response);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> doneTodo(TodoEntity params) async {
    try {
      final response = await localDataSource.doneTodo(params);

      return Right(response);
    } catch (e) {
      return Left(ClientFailure());
    }
  }
}
