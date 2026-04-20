import '../entities/todo_task.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository _repository;

  CreateTaskUseCase(this._repository);

  Future<TodoTask> execute({
    required String title,
    String? description,
  }) async {
    if (title.trim().isEmpty) {
      throw Exception('Task title cannot be empty');
    }
    return await _repository.createTask(
      title: title,
      description: description,
    );
  }
}
