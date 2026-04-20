import '../entities/todo_task.dart';
import '../repositories/task_repository.dart';

class FetchTasksUseCase {
  final TaskRepository _repository;

  FetchTasksUseCase(this._repository);

  Future<List<TodoTask>> execute({
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

  Future<TodoTask?> getById(String id) async {
    return await _repository.getTaskById(id);
  }
}
