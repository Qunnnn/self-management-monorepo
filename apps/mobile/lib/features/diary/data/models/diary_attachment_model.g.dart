// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryAttachmentModel _$DiaryAttachmentModelFromJson(
  Map<String, dynamic> json,
) => DiaryAttachmentModel(
  id: json['id'] as String,
  fileUrl: json['file_url'] as String,
  fileType: json['file_type'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$DiaryAttachmentModelToJson(
  DiaryAttachmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'file_url': instance.fileUrl,
  'file_type': instance.fileType,
  'created_at': instance.createdAt.toIso8601String(),
};
