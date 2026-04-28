import 'package:mobile/core/import/app_imports.dart';

part 'diary_action_provider.g.dart';

@riverpod
class DiaryActionNotifier extends _$DiaryActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> updateEntry(DiaryEntry entry) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref.read(updateDiaryEntryUseCaseProvider).execute(entry),
    );

    if (!ref.mounted) return;

    if (result is AsyncError) {
      state = AsyncValue.error(result.error, result.stackTrace);
      return;
    }

    final currentEntries = ref.read(diaryProvider).value?.items ?? [];
    ref
        .read(diaryProvider.notifier)
        .updateState(
          currentEntries.map((e) => e.id == entry.id ? entry : e).toList(),
        );
    state = const AsyncValue.data(null);
  }

  Future<void> deleteEntry(String id) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref.read(deleteDiaryEntryUseCaseProvider).execute(id),
    );

    if (!ref.mounted) return;

    if (result is AsyncError) {
      state = AsyncValue.error(result.error, result.stackTrace);
      return;
    }

    final currentEntries = ref.read(diaryProvider).value?.items ?? [];
    ref
        .read(diaryProvider.notifier)
        .updateState(currentEntries.where((e) => e.id != id).toList());
    state = const AsyncValue.data(null);
  }

  Future<void> togglePin(DiaryEntry entry) async {
    state = const AsyncValue.loading();
    final updated = entry.copyWith(isPinned: !entry.isPinned);
    final result = await AsyncValue.guard(
      () => ref.read(togglePinUseCaseProvider).execute(updated),
    );

    if (!ref.mounted) return;

    if (result is AsyncError) {
      state = AsyncValue.error(result.error, result.stackTrace);
      return;
    }

    final currentEntries = ref.read(diaryProvider).value?.items ?? [];
    ref
        .read(diaryProvider.notifier)
        .updateState(
          currentEntries.map((e) => e.id == entry.id ? updated : e).toList(),
        );
    state = const AsyncValue.data(null);
  }
}
