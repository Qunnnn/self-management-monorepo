import 'package:freezed_annotation/freezed_annotation.dart';
import 'diary_mood.dart';
import 'diary_attachment.dart';

part 'diary_entry.freezed.dart';

@freezed
abstract class DiaryEntry with _$DiaryEntry {
  const factory DiaryEntry({
    required String id,
    required String title,
    @Default('') String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isPinned,
    DiaryMood? mood,
    double? latitude,
    double? longitude,
    @Default([]) List<DiaryAttachment> attachments,
  }) = _DiaryEntry;
}
