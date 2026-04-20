import '../../domain/entities/diary_entry.dart';
import '../../domain/repositories/diary_repository.dart';
import '../data_sources/diary_mock_data_source.dart';
import '../models/diary_entry_model.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryMockDataSource _dataSource;

  DiaryRepositoryImpl(this._dataSource);

  @override
  Future<List<DiaryEntry>> getAllEntries() async {
    final models = await _dataSource.getAllEntries();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<DiaryEntry?> getEntryById(String id) async {
    final entries = await getAllEntries();
    try {
      return entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveEntry(DiaryEntry entry) async {
    final model = DiaryEntryModel.fromEntity(entry);
    await _dataSource.saveEntry(model);
  }

  @override
  Future<void> updateEntry(DiaryEntry entry) async {
    final model = DiaryEntryModel.fromEntity(entry);
    await _dataSource.updateEntry(model);
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _dataSource.deleteEntry(id);
  }
}
