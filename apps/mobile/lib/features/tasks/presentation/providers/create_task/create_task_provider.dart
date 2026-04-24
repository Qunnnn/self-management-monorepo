import 'package:mobile/core/import/app_imports.dart';

part 'create_task_provider.g.dart';

@riverpod
class CreateTaskNotifier extends _$CreateTaskNotifier {
  late final FormGroup form;

  @override
  FutureOr<void> build() {
    form = fb.group({
      'title': ['', Validators.required],
      'description': [''],
    });

    ref.onDispose(form.dispose);
  }

  Future<void> submit() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    state = const AsyncValue.loading();
    
    final title = form.control('title').value as String;
    final description = form.control('description').value as String?;
    
    final result = await ref.read(createTaskUseCaseProvider).execute(
          title: title,
          description: description?.isEmpty ?? true ? null : description,
        );
    
    if (!ref.mounted) return;

    result.match(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (newTask) {
        // Update core state
        final currentTasks = ref.read(tasksProvider).value ?? [];
        ref.read(tasksProvider.notifier).updateState([...currentTasks, newTask]);
        
        state = const AsyncValue.data(null);
      },
    );
  }
}
