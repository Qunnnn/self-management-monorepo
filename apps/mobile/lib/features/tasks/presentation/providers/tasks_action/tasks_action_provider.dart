import 'package:mobile/core/import/app_imports.dart';

part 'tasks_action_provider.g.dart';

@riverpod
class TasksActionNotifier extends _$TasksActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addTask(String title, String? description) async {
    state = const AsyncValue.loading();
    final result = await ref.read(createTaskUseCaseProvider).execute(
          title: title,
          description: description,
        );
    
    if (!ref.mounted) return;

    result.match(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (newTask) {
        final currentTasks = ref.read(tasksProvider).value ?? [];
        ref.read(tasksProvider.notifier).updateState([...currentTasks, newTask]);
        state = const AsyncValue.data(null);
      },
    );
  }

  Future<void> toggleTaskCompletion(TodoTask task) async {
    state = const AsyncValue.loading();
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    final result = await ref.read(updateTasksUseCaseProvider).execute(updatedTask);
    
    if (!ref.mounted) return;

    result.match(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        final currentTasks = ref.read(tasksProvider).value ?? [];
        ref.read(tasksProvider.notifier).updateState(
          currentTasks.map((t) => t.id == task.id ? updatedTask : t).toList(),
        );
        state = const AsyncValue.data(null);
      },
    );
  }

  Future<void> deleteTask(String id) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteTaskUseCaseProvider).execute(id);
    
    if (!ref.mounted) return;

    result.match(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        final currentTasks = ref.read(tasksProvider).value ?? [];
        ref.read(tasksProvider.notifier).updateState(
          currentTasks.where((t) => t.id != id).toList(),
        );
        state = const AsyncValue.data(null);
      },
    );
  }
}
