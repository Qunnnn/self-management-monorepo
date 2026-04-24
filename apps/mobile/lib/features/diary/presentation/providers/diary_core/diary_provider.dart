import 'package:mobile/core/import/app_imports.dart';

part 'diary_provider.g.dart';

@riverpod
class DiaryNotifier extends _$DiaryNotifier {
  late final FormGroup searchForm;

  @override
  FutureOr<DiaryState> build() async {
    searchForm = fb.group({
      'query': [''],
    });

    ref.onDispose(searchForm.dispose);

    final entries = await _fetchEntries('');
    return DiaryState(items: entries);
  }

  Future<List<DiaryEntry>> _fetchEntries(String query) async {
    if (query.isEmpty) {
      return await ref.read(fetchDiaryEntriesUseCaseProvider).execute();
    } else {
      return await ref.read(fetchDiaryEntriesUseCaseProvider).search(query);
    }
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final entries = await _fetchEntries(query);
      return DiaryState(items: entries);
    });
  }

  Future<void> refresh() async {
    final currentQuery = searchForm.control('query').value as String? ?? '';
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final entries = await _fetchEntries(currentQuery);
      return DiaryState(items: entries);
    });
  }

  void updateState(List<DiaryEntry> entries) {
    state = AsyncValue.data(
      state.value?.copyWith(items: entries) ?? DiaryState(items: entries),
    );
  }
}
