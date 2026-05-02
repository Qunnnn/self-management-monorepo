//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'modify_user_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ModifyUserRequest {
  /// Returns a new [ModifyUserRequest] instance.
  ModifyUserRequest({

     this.name,

     this.email,

     this.phoneNumber,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



  @JsonKey(
    
    name: r'phoneNumber',
    required: false,
    includeIfNull: false,
  )


  final String? phoneNumber;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ModifyUserRequest &&
      other.name == name &&
      other.email == email &&
      other.phoneNumber == phoneNumber;

    @override
    int get hashCode =>
        name.hashCode +
        email.hashCode +
        phoneNumber.hashCode;

  factory ModifyUserRequest.fromJson(Map<String, dynamic> json) => _$ModifyUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ModifyUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

