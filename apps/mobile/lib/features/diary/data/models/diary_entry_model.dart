import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/entities/diary_mood.dart';
import 'diary_attachment_model.dart';

part 'diary_entry_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DiaryEntryModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final DiaryMood? mood;
  final double? latitude;
  final double? longitude;
  final List<DiaryAttachmentModel> attachments;

  const DiaryEntryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    this.mood,
    this.latitude,
    this.longitude,
    required this.attachments,
  });

  factory DiaryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DiaryEntryModelToJson(this);

  factory DiaryEntryModel.fromEntity(DiaryEntry entity) => DiaryEntryModel(
    id: entity.id,
    title: entity.title,
    content: entity.content,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    isPinned: entity.isPinned,
    mood: entity.mood,
    latitude: entity.latitude,
    longitude: entity.longitude,
    attachments: entity.attachments
        .map((a) => DiaryAttachmentModel.fromEntity(a))
        .toList(),
  );

  DiaryEntry toEntity() => DiaryEntry(
    id: id,
    title: title,
    content: content,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isPinned: isPinned,
    mood: mood,
    latitude: latitude,
    longitude: longitude,
    attachments: attachments.map((a) => a.toEntity()).toList(),
  );
}
