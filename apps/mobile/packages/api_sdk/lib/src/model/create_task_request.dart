//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_task_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateTaskRequest {
  /// Returns a new [CreateTaskRequest] instance.
  CreateTaskRequest({

    required  this.title,

     this.description,
  });

  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateTaskRequest &&
      other.title == title &&
      other.description == description;

    @override
    int get hashCode =>
        title.hashCode +
        description.hashCode;

  factory CreateTaskRequest.fromJson(Map<String, dynamic> json) => _$CreateTaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

