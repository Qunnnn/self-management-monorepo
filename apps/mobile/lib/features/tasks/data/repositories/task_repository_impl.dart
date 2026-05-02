import '../../domain/entities/todo_task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<TodoTask>>> getTasks({
    bool? completed,
    int? limit,
    int? offset,
  }) async {
    return await _dataSource.getTasks(
      completed: completed,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Either<Failure, TodoTask?>> getTaskById(String id) async {
    return await _dataSource.getTaskById(id);
  }

  @override
  Future<Either<Failure, TodoTask>> createTask({
    required String title,
    String? description,
  }) async {
    return await _dataSource.createTask(
      title: title,
      description: description,
    );
  }

  @override
  Future<Either<Failure, TodoTask>> updateTask(TodoTask task) async {
    return await _dataSource.updateTask(task);
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    return _dataSource.deleteTask(id);
  }
}
