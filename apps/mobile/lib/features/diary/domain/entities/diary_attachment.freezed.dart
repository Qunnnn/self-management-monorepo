// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DiaryAttachment {
  String get id => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String? get fileType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of DiaryAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiaryAttachmentCopyWith<DiaryAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryAttachmentCopyWith<$Res> {
  factory $DiaryAttachmentCopyWith(
    DiaryAttachment value,
    $Res Function(DiaryAttachment) then,
  ) = _$DiaryAttachmentCopyWithImpl<$Res, DiaryAttachment>;
  @useResult
  $Res call({String id, String fileUrl, String? fileType, DateTime createdAt});
}

/// @nodoc
class _$DiaryAttachmentCopyWithImpl<$Res, $Val extends DiaryAttachment>
    implements $DiaryAttachmentCopyWith<$Res> {
  _$DiaryAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiaryAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileUrl = null,
    Object? fileType = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fileUrl: null == fileUrl
                ? _value.fileUrl
                : fileUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            fileType: freezed == fileType
                ? _value.fileType
                : fileType // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiaryAttachmentImplCopyWith<$Res>
    implements $DiaryAttachmentCopyWith<$Res> {
  factory _$$DiaryAttachmentImplCopyWith(
    _$DiaryAttachmentImpl value,
    $Res Function(_$DiaryAttachmentImpl) then,
  ) = __$$DiaryAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fileUrl, String? fileType, DateTime createdAt});
}

/// @nodoc
class __$$DiaryAttachmentImplCopyWithImpl<$Res>
    extends _$DiaryAttachmentCopyWithImpl<$Res, _$DiaryAttachmentImpl>
    implements _$$DiaryAttachmentImplCopyWith<$Res> {
  __$$DiaryAttachmentImplCopyWithImpl(
    _$DiaryAttachmentImpl _value,
    $Res Function(_$DiaryAttachmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiaryAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileUrl = null,
    Object? fileType = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$DiaryAttachmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fileUrl: null == fileUrl
            ? _value.fileUrl
            : fileUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        fileType: freezed == fileType
            ? _value.fileType
            : fileType // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$DiaryAttachmentImpl implements _DiaryAttachment {
  const _$DiaryAttachmentImpl({
    required this.id,
    required this.fileUrl,
    this.fileType,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String fileUrl;
  @override
  final String? fileType;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'DiaryAttachment(id: $id, fileUrl: $fileUrl, fileType: $fileType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryAttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fileUrl, fileType, createdAt);

  /// Create a copy of DiaryAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryAttachmentImplCopyWith<_$DiaryAttachmentImpl> get copyWith =>
      __$$DiaryAttachmentImplCopyWithImpl<_$DiaryAttachmentImpl>(
        this,
        _$identity,
      );
}

abstract class _DiaryAttachment implements DiaryAttachment {
  const factory _DiaryAttachment({
    required final String id,
    required final String fileUrl,
    final String? fileType,
    required final DateTime createdAt,
  }) = _$DiaryAttachmentImpl;

  @override
  String get id;
  @override
  String get fileUrl;
  @override
  String? get fileType;
  @override
  DateTime get createdAt;

  /// Create a copy of DiaryAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiaryAttachmentImplCopyWith<_$DiaryAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
