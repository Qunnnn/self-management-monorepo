import '../models/task_model.dart';

class TaskMockDataSource {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      userId: 'user-1',
      title: 'Design Phase 2',
      description: 'Create the implementation plan for the tasks feature.',
      isCompleted: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: '2',
      userId: 'user-1',
      title: 'Implement Task Entity',
      description: 'Port the TodoTask entity from iOS to Flutter.',
      isCompleted: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    TaskModel(
      id: '3',
      userId: 'user-1',
      title: 'Create Tasks Page',
      description: 'Build the main tasks list UI with Notion aesthetics.',
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
    TaskModel(
      id: '4',
      userId: 'user-1',
      title: 'Integrate with Finance',
      description: 'Phase 3 will involve finance feature migration.',
      isCompleted: false,
      createdAt: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  Future<List<TaskModel>> getTasks({
    bool? completed,
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    var filtered = _tasks;
    if (completed != null) {
      filtered = filtered.where((t) => t.isCompleted == completed).toList();
    }
    return filtered;
  }

  Future<TaskModel?> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks.firstWhere((t) => t.id == id);
  }

  Future<TaskModel> createTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _tasks.add(task);
    return task;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
    return task;
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _tasks.removeWhere((t) => t.id == id);
  }
}
