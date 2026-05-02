import 'package:fpdart/fpdart.dart' hide Task;
import 'package:mobile/core/network/index.dart';
import 'package:api_client/api_client.dart';
import 'package:mobile/features/tasks/domain/entities/todo_task.dart';

abstract class TaskRemoteDataSource {
  Future<Either<Failure, List<TodoTask>>> getTasks({bool? completed, int? limit, int? offset});
  Future<Either<Failure, TodoTask?>> getTaskById(String id);
  Future<Either<Failure, TodoTask>> createTask({required String title, String? description});
  Future<Either<Failure, TodoTask>> updateTask(TodoTask task);
  Future<Either<Failure, void>> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final DioClient _dioClient;
  final DefaultApi _api;

  TaskRemoteDataSourceImpl(this._dioClient, this._api);

  @override
  Future<Either<Failure, List<TodoTask>>> getTasks({
    bool? completed,
    int? limit,
    int? offset,
  }) async {
    return _dioClient.request(() async {
      final response = await _api.tasksGet();
      var tasks = response.data!;
      if (completed != null) {
        tasks = tasks.where((t) => t.isCompleted == completed).toList();
      }
      return tasks.map((t) => _mapToEntity(t)).toList();
    });
  }

  @override
  Future<Either<Failure, TodoTask?>> getTaskById(String id) async {
    return _dioClient.request(() async {
      final response = await _api.tasksIdGet(id: id);
      return _mapToEntity(response.data!);
    });
  }

  @override
  Future<Either<Failure, TodoTask>> createTask({
    required String title,
    String? description,
  }) async {
    return _dioClient.request(() async {
      final response = await _api.tasksPost(
        createTaskRequest: CreateTaskRequest(title: title, description: description),
      );
      return _mapToEntity(response.data!);
    });
  }

  @override
  Future<Either<Failure, TodoTask>> updateTask(TodoTask task) async {
    return _dioClient.request(() async {
      if (task.isCompleted) {
        final response = await _api.tasksIdCompletePatch(id: task.id);
        return _mapToEntity(response.data!);
      }
      return task;
    });
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    return _dioClient.request(() async {
      await _api.tasksIdDelete(id: id);
    });
  }

  TodoTask _mapToEntity(Task task) {
    return TodoTask(
      id: task.id ?? '',
      userId: task.userId ?? '',
      title: task.title ?? '',
      description: task.description,
      isCompleted: task.isCompleted ?? false,
      createdAt: task.createdAt ?? DateTime.now(),
      deletedAt: task.deletedAt,
    );
  }
}
