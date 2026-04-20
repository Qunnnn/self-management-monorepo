import '../../domain/entities/todo_task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_mock_data_source.dart';
import '../models/task_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskMockDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<TodoTask>>> getTasks({
    bool? completed,
    int? limit,
    int? offset,
  }) async {
    final result = await _dataSource.getTasks(
      completed: completed,
      limit: limit,
      offset: offset,
    );
    return result.map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<Failure, TodoTask?>> getTaskById(String id) async {
    final result = await _dataSource.getTaskById(id);
    return result.map((model) => model?.toEntity());
  }

  @override
  Future<Either<Failure, TodoTask>> createTask({
    required String title,
    String? description,
  }) async {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user-1', // Mock user
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    final result = await _dataSource.createTask(newTask);
    return result.map((m) => m.toEntity());
  }

  @override
  Future<Either<Failure, TodoTask>> updateTask(TodoTask task) async {
    final model = TaskModel.fromEntity(task);
    final result = await _dataSource.updateTask(model);
    return result.map((m) => m.toEntity());
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    return _dataSource.deleteTask(id);
  }
}
