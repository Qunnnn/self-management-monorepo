import '../entities/todo_task.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TodoTask>>> getTasks({
    bool? completed,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, TodoTask?>> getTaskById(String id);

  Future<Either<Failure, TodoTask>> createTask({
    required String title,
    String? description,
  });

  Future<Either<Failure, TodoTask>> updateTask(TodoTask task);

  Future<Either<Failure, void>> deleteTask(String id);
}
