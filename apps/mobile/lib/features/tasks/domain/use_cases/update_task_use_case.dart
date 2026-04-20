import '../entities/todo_task.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<TodoTask> execute(TodoTask task) async {
    return await _repository.updateTask(task);
  }
}
