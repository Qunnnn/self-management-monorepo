// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryEntryModel _$DiaryEntryModelFromJson(Map<String, dynamic> json) =>
    DiaryEntryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isPinned: json['is_pinned'] as bool,
      mood: $enumDecodeNullable(_$DiaryMoodEnumMap, json['mood']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => DiaryAttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiaryEntryModelToJson(DiaryEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'is_pinned': instance.isPinned,
      'mood': _$DiaryMoodEnumMap[instance.mood],
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
    };

const _$DiaryMoodEnumMap = {
  DiaryMood.happy: 'happy',
  DiaryMood.productive: 'productive',
  DiaryMood.tired: 'tired',
  DiaryMood.neutral: 'neutral',
};
