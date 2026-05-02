//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Task {
  /// Returns a new [Task] instance.
  Task({

     this.id,

     this.userId,

     this.title,

     this.description,

     this.isCompleted,

     this.createdAt,

     this.deletedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'userId',
    required: false,
    includeIfNull: false,
  )


  final String? userId;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false,
  )


  final String? title;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'isCompleted',
    required: false,
    includeIfNull: false,
  )


  final bool? isCompleted;



  @JsonKey(
    
    name: r'createdAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? createdAt;



  @JsonKey(
    
    name: r'deletedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? deletedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Task &&
      other.id == id &&
      other.userId == userId &&
      other.title == title &&
      other.description == description &&
      other.isCompleted == isCompleted &&
      other.createdAt == createdAt &&
      other.deletedAt == deletedAt;

    @override
    int get hashCode =>
        id.hashCode +
        userId.hashCode +
        title.hashCode +
        description.hashCode +
        isCompleted.hashCode +
        createdAt.hashCode +
        (deletedAt == null ? 0 : deletedAt.hashCode);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

