import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'auth_tokens_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final UserModel user;
  final AuthTokensModel tokens;

  const LoginResponseModel({
    required this.user,
    required this.tokens,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
