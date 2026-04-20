import '../../domain/entities/diary_mood.dart';
import '../models/diary_entry_model.dart';

class DiaryMockDataSource {
  final List<DiaryEntryModel> _entries = [
    DiaryEntryModel(
      id: '1',
      title: 'Productive Monday',
      content: 'Finished the migration phase 3 today! Feeling great about the progress.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      isPinned: true,
      mood: DiaryMood.productive,
      attachments: [],
    ),
    DiaryEntryModel(
      id: '2',
      title: 'Evening Walk',
      content: 'The weather was perfect for a long walk. Saw a beautiful sunset.',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      isPinned: false,
      mood: DiaryMood.happy,
      attachments: [],
    ),
    DiaryEntryModel(
      id: '3',
      title: 'Rough Night',
      content: 'Didnt sleep well. Hope tomorrow is better.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      isPinned: false,
      mood: DiaryMood.tired,
      attachments: [],
    ),
  ];

  Future<List<DiaryEntryModel>> getAllEntries() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _entries;
  }

  Future<void> saveEntry(DiaryEntryModel entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.add(entry);
  }

  Future<void> updateEntry(DiaryEntryModel entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  Future<void> deleteEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((e) => e.id == id);
  }
}
