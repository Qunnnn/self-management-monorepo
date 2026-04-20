// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryAttachmentModel _$DiaryAttachmentModelFromJson(
  Map<String, dynamic> json,
) => DiaryAttachmentModel(
  id: json['id'] as String,
  fileUrl: json['fileUrl'] as String,
  fileType: json['fileType'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$DiaryAttachmentModelToJson(
  DiaryAttachmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileUrl': instance.fileUrl,
  'fileType': instance.fileType,
  'createdAt': instance.createdAt.toIso8601String(),
};
