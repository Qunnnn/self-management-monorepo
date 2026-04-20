import '../entities/todo_task.dart';

abstract class TaskRepository {
  Future<List<TodoTask>> getTasks({
    bool? completed,
    int? limit,
    int? offset,
  });

  Future<TodoTask?> getTaskById(String id);

  Future<TodoTask> createTask({
    required String title,
    String? description,
  });

  Future<TodoTask> updateTask(TodoTask task);

  Future<void> deleteTask(String id);
}
