import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/diary_mock_data_source.dart';
import '../../data/repositories/diary_repository_impl.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/repositories/diary_repository.dart';
import '../../domain/use_cases/diary_use_cases.dart';

part 'diary_provider.g.dart';

@riverpod
DiaryMockDataSource diaryDataSource(Ref ref) {
  return DiaryMockDataSource();
}

@riverpod
DiaryRepository diaryRepository(Ref ref) {
  return DiaryRepositoryImpl(ref.watch(diaryDataSourceProvider));
}

@riverpod
FetchDiaryEntriesUseCase fetchDiaryEntriesUseCase(Ref ref) {
  return FetchDiaryEntriesUseCase(ref.watch(diaryRepositoryProvider));
}

@riverpod
CreateDiaryEntryUseCase createDiaryEntryUseCase(Ref ref) {
  return CreateDiaryEntryUseCase(ref.watch(diaryRepositoryProvider));
}

@riverpod
UpdateDiaryEntryUseCase updateDiaryEntryUseCase(Ref ref) {
  return UpdateDiaryEntryUseCase(ref.watch(diaryRepositoryProvider));
}

@riverpod
DeleteDiaryEntryUseCase deleteDiaryEntryUseCase(Ref ref) {
  return DeleteDiaryEntryUseCase(ref.watch(diaryRepositoryProvider));
}

@riverpod
TogglePinUseCase togglePinUseCase(Ref ref) {
  return TogglePinUseCase(ref.watch(diaryRepositoryProvider));
}

@riverpod
class DiaryNotifier extends _$DiaryNotifier {
  String _searchQuery = '';

  @override
  FutureOr<List<DiaryEntry>> build() async {
    return _fetchEntries();
  }

  Future<List<DiaryEntry>> _fetchEntries() async {
    if (_searchQuery.isEmpty) {
      return await ref.read(fetchDiaryEntriesUseCaseProvider).execute();
    } else {
      return await ref.read(fetchDiaryEntriesUseCaseProvider).search(_searchQuery);
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchEntries());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchEntries());
  }

  Future<void> createEntry(DiaryEntry entry) async {
    await ref.read(createDiaryEntryUseCaseProvider).execute(entry);
    state.whenData((entries) {
      state = AsyncValue.data([entry, ...entries]);
    });
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    await ref.read(updateDiaryEntryUseCaseProvider).execute(entry);
    state.whenData((entries) {
      state = AsyncValue.data(
        entries.map((e) => e.id == entry.id ? entry : e).toList(),
      );
    });
  }

  Future<void> deleteEntry(String id) async {
    await ref.read(deleteDiaryEntryUseCaseProvider).execute(id);
    state.whenData((entries) {
      state = AsyncValue.data(
        entries.where((e) => e.id != id).toList(),
      );
    });
  }

  Future<void> togglePin(DiaryEntry entry) async {
    final updated = entry.copyWith(isPinned: !entry.isPinned);
    await ref.read(togglePinUseCaseProvider).execute(updated);
    state.whenData((entries) {
      state = AsyncValue.data(
        entries.map((e) => e.id == entry.id ? updated : e).toList(),
      );
    });
  }
}
