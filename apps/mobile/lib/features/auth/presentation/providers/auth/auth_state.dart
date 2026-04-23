import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/auth_tokens.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  initial,
  authenticated,
  unAuthenticated,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    AuthTokens? tokens,
  }) = _AuthState;
}
