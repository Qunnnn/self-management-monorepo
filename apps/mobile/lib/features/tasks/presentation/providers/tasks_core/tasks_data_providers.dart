import 'package:mobile/core/import/app_imports.dart';

part 'tasks_data_providers.g.dart';

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
