import '../entities/todo_task.dart';
import '../repositories/task_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<Either<Failure, TodoTask>> execute(TodoTask task) async {
    return await _repository.updateTask(task);
  }
}
