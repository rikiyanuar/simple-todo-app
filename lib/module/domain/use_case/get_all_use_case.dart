import '../../external/libraries/dartz.dart';
import '../entity/failure.dart';
import '../entity/todo_entity.dart';
import '../repositories/app_repository.dart';
import 'use_case.dart';

class GetAllUseCase implements UseCase<List<TodoEntity>, NoParams> {
  final AppRepository repository;

  GetAllUseCase({required this.repository});

  @override
  Future<Either<Failure, List<TodoEntity>>> call(NoParams params) {
    return repository.getAll();
  }
}
