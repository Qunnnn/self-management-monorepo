import '../entities/todo_task.dart';
import '../repositories/task_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

class CreateTaskUseCase {
  final TaskRepository _repository;

  CreateTaskUseCase(this._repository);

  Future<Either<Failure, TodoTask>> execute({
    required String title,
    String? description,
  }) async {
    if (title.trim().isEmpty) {
      return const Left(ValidationFailure('Task title cannot be empty'));
    }
    return await _repository.createTask(title: title, description: description);
  }
}
