//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_stats.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserStats {
  /// Returns a new [UserStats] instance.
  UserStats({

     this.totalUsers,

     this.activeTasks,
  });

  @JsonKey(
    
    name: r'totalUsers',
    required: false,
    includeIfNull: false,
  )


  final int? totalUsers;



  @JsonKey(
    
    name: r'activeTasks',
    required: false,
    includeIfNull: false,
  )


  final int? activeTasks;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserStats &&
      other.totalUsers == totalUsers &&
      other.activeTasks == activeTasks;

    @override
    int get hashCode =>
        totalUsers.hashCode +
        activeTasks.hashCode;

  factory UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

