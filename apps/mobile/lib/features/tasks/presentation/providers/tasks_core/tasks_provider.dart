import 'package:mobile/core/import/app_imports.dart';

part 'tasks_provider.g.dart';

@riverpod
class TasksNotifier extends _$TasksNotifier {
  @override
  FutureOr<List<TodoTask>> build() async {
    return _fetchTasks();
  }

  Future<List<TodoTask>> _fetchTasks() async {
    final result = await ref.read(fetchTasksUseCaseProvider).execute();
    return result.match(
      (failure) => throw failure,
      (tasks) => tasks,
    );
  }

  /// Updates the current state with a new list of tasks or error.
  /// This is used by action notifiers to sync state.
  void updateState(List<TodoTask> tasks) {
    state = AsyncValue.data(tasks);
  }

  /// Forces a refresh of the task list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTasks());
  }
}
