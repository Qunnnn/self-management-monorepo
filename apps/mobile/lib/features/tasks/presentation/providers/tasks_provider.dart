import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/task_mock_data_source.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/use_cases/create_task_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/fetch_tasks_use_case.dart';
import '../../domain/use_cases/update_task_use_case.dart';

part 'tasks_provider.g.dart';

@riverpod
TaskMockDataSource taskDataSource(Ref ref) {
  return TaskMockDataSource();
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskRepositoryImpl(ref.watch(taskDataSourceProvider));
}

@riverpod
FetchTasksUseCase fetchTasksUseCase(Ref ref) {
  return FetchTasksUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
CreateTaskUseCase createTaskUseCase(Ref ref) {
  return CreateTaskUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
UpdateTaskUseCase updateTasksUseCase(Ref ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
DeleteTaskUseCase deleteTaskUseCase(Ref ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
class TasksNotifier extends _$TasksNotifier {
  @override
  FutureOr<List<TodoTask>> build() async {
    return _fetchTasks();
  }

  Future<List<TodoTask>> _fetchTasks() async {
    return await ref.read(fetchTasksUseCaseProvider).execute();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTasks());
  }

  Future<void> addTask(String title, String? description) async {
    final newTask = await ref.read(createTaskUseCaseProvider).execute(
          title: title,
          description: description,
        );
    
    state.whenData((tasks) {
      state = AsyncValue.data([...tasks, newTask]);
    });
  }

  Future<void> toggleTaskCompletion(TodoTask task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await ref.read(updateTasksUseCaseProvider).execute(updatedTask);
    
    state.whenData((tasks) {
      state = AsyncValue.data(
        tasks.map((t) => t.id == task.id ? updatedTask : t).toList(),
      );
    });
  }

  Future<void> deleteTask(String id) async {
    await ref.read(deleteTaskUseCaseProvider).execute(id);
    
    state.whenData((tasks) {
      state = AsyncValue.data(
        tasks.where((t) => t.id != id).toList(),
      );
    });
  }
}
