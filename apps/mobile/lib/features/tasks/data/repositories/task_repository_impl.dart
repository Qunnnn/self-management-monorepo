import '../../domain/entities/todo_task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_mock_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskMockDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<List<TodoTask>> getTasks({
    bool? completed,
    int? limit,
    int? offset,
  }) async {
    final models = await _dataSource.getTasks(
      completed: completed,
      limit: limit,
      offset: offset,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TodoTask?> getTaskById(String id) async {
    final model = await _dataSource.getTaskById(id);
    return model?.toEntity();
  }

  @override
  Future<TodoTask> createTask({
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
    return result.toEntity();
  }

  @override
  Future<TodoTask> updateTask(TodoTask task) async {
    final model = TaskModel.fromEntity(task);
    final result = await _dataSource.updateTask(model);
    return result.toEntity();
  }

  @override
  Future<void> deleteTask(String id) async {
    await _dataSource.deleteTask(id);
  }
}
