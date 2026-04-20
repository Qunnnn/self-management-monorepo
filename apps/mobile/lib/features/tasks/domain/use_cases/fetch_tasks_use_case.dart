import '../entities/todo_task.dart';
import '../repositories/task_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

class FetchTasksUseCase {
  final TaskRepository _repository;

  FetchTasksUseCase(this._repository);

  Future<Either<Failure, List<TodoTask>>> execute({
    bool? completed,
    int? limit,
    int? offset,
  }) async {
    return await _repository.getTasks(
      completed: completed,
      limit: limit,
      offset: offset,
    );
  }

  Future<Either<Failure, TodoTask?>> getById(String id) async {
    return await _repository.getTaskById(id);
  }
}
