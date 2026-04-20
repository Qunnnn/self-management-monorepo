import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_attachment.freezed.dart';

@freezed
class DiaryAttachment with _$DiaryAttachment {
  const factory DiaryAttachment({
    required String id,
    required String fileUrl,
    String? fileType,
    required DateTime createdAt,
  }) = _DiaryAttachment;
}
