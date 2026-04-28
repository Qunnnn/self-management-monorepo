import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class FetchDiaryEntriesUseCase {
  final DiaryRepository _repository;

  FetchDiaryEntriesUseCase(this._repository);

  Future<List<DiaryEntry>> execute() async {
    final entries = await _repository.getAllEntries();
    return _sortEntries(entries);
  }

  Future<List<DiaryEntry>> search(String query) async {
    final entries = await _repository.getAllEntries();
    if (query.isEmpty) return _sortEntries(entries);

    final lowerQuery = query.toLowerCase();
    final filtered = entries.where((entry) {
      return entry.title.toLowerCase().contains(lowerQuery) ||
          entry.content.toLowerCase().contains(lowerQuery);
    }).toList();

    return _sortEntries(filtered);
  }

  List<DiaryEntry> _sortEntries(List<DiaryEntry> entries) {
    return entries.toList()..sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }
}

class CreateDiaryEntryUseCase {
  final DiaryRepository _repository;
  CreateDiaryEntryUseCase(this._repository);
  Future<void> execute(DiaryEntry entry) => _repository.saveEntry(entry);
}

class UpdateDiaryEntryUseCase {
  final DiaryRepository _repository;
  UpdateDiaryEntryUseCase(this._repository);
  Future<void> execute(DiaryEntry entry) => _repository.updateEntry(entry);
}

class DeleteDiaryEntryUseCase {
  final DiaryRepository _repository;
  DeleteDiaryEntryUseCase(this._repository);
  Future<void> execute(String id) => _repository.deleteEntry(id);
}

class TogglePinUseCase {
  final DiaryRepository _repository;
  TogglePinUseCase(this._repository);

  Future<void> execute(DiaryEntry entry) async {
    final updated = entry.copyWith(
      isPinned: !entry.isPinned,
      updatedAt: DateTime.now(),
    );
    await _repository.updateEntry(updated);
  }
}
