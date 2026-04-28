import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_tokens.dart';

part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

@freezed
class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokensModel;

  const AuthTokensModel._();

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  factory AuthTokensModel.fromEntity(AuthTokens tokens) => AuthTokensModel(
    accessToken: tokens.accessToken,
    refreshToken: tokens.refreshToken,
  );

  AuthTokens toEntity() =>
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}
