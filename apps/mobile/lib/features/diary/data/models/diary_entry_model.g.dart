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
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool,
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
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isPinned': instance.isPinned,
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
