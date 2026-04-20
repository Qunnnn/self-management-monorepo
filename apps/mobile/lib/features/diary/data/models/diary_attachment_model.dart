import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/diary_attachment.dart';

part 'diary_attachment_model.g.dart';

@JsonSerializable()
class DiaryAttachmentModel {
  final String id;
  final String fileUrl;
  final String? fileType;
  final DateTime createdAt;

  const DiaryAttachmentModel({
    required this.id,
    required this.fileUrl,
    this.fileType,
    required this.createdAt,
  });

  factory DiaryAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryAttachmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DiaryAttachmentModelToJson(this);

  factory DiaryAttachmentModel.fromEntity(DiaryAttachment entity) =>
      DiaryAttachmentModel(
        id: entity.id,
        fileUrl: entity.fileUrl,
        fileType: entity.fileType,
        createdAt: entity.createdAt,
      );

  DiaryAttachment toEntity() => DiaryAttachment(
        id: id,
        fileUrl: fileUrl,
        fileType: fileType,
        createdAt: createdAt,
      );
}
