import 'package:mobile/core/import/app_imports.dart';

part 'entry_editor_provider.g.dart';

@riverpod
class EntryEditorNotifier extends _$EntryEditorNotifier {
  late final FormGroup form;
  DiaryEntry? _existingEntry;

  @override
  FutureOr<void> build({String? entryId}) async {
    form = fb.group({
      AppFormControls.title: ['', Validators.required],
      DiaryFormControls.content: [''],
      DiaryFormControls.mood: [null as DiaryMood?],
    });

    if (entryId != null) {
      final entries = await ref.read(diaryProvider.future);
      _existingEntry = entries.items.firstWhere((e) => e.id == entryId);
      if (_existingEntry != null) {
        form.patchValue({
          AppFormControls.title: _existingEntry!.title,
          DiaryFormControls.content: _existingEntry!.content,
          DiaryFormControls.mood: _existingEntry!.mood,
        });
      }
    }

    ref.onDispose(form.dispose);
  }

  Future<void> save() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    state = const AsyncValue.loading();

    final values = form.value;
    final title = values[AppFormControls.title] as String;
    final content = values[DiaryFormControls.content] as String;
    final mood = values[DiaryFormControls.mood] as DiaryMood?;

    try {
      if (_existingEntry != null) {
        final updated = _existingEntry!.copyWith(
          title: title,
          content: content,
          mood: mood,
          updatedAt: DateTime.now(),
        );
        await ref.read(updateDiaryEntryUseCaseProvider).execute(updated);

        // Update core state
        final currentEntries = ref.read(diaryProvider).value?.items ?? [];
        ref
            .read(diaryProvider.notifier)
            .updateState(
              currentEntries
                  .map((e) => e.id == updated.id ? updated : e)
                  .toList(),
            );
      } else {
        final entry = DiaryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          mood: mood,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await ref.read(createDiaryEntryUseCaseProvider).execute(entry);

        // Update core state
        final currentEntries = ref.read(diaryProvider).value?.items ?? [];
        ref.read(diaryProvider.notifier).updateState([
          entry,
          ...currentEntries,
        ]);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete() async {
    if (_existingEntry == null) return;

    state = const AsyncValue.loading();
    try {
      await ref
          .read(deleteDiaryEntryUseCaseProvider)
          .execute(_existingEntry!.id);

      // Update core state
      final currentEntries = ref.read(diaryProvider).value?.items ?? [];
      ref
          .read(diaryProvider.notifier)
          .updateState(
            currentEntries.where((e) => e.id != _existingEntry!.id).toList(),
          );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
