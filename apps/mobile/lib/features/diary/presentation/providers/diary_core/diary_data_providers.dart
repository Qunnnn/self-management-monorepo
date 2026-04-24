import 'package:mobile/core/import/app_imports.dart';

part 'diary_data_providers.g.dart';

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
