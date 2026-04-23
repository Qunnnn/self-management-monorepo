import 'package:mobile/core/import/app_imports.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() async {
    // Initial loading from storage
    final tokens = await ref.read(tokenStorageProvider).loadTokens();

    if (tokens != null) {
      return AuthState(status: AuthStatus.authenticated, tokens: tokens);
    }

    return const AuthState(status: AuthStatus.unAuthenticated);
  }

  /// Manually update the authentication state.
  /// This is called by specialized providers like loginProvider or logoutProvider.
  void updateState(AuthTokens? tokens) {
    if (tokens != null) {
      state = AsyncValue.data(
        AuthState(status: AuthStatus.authenticated, tokens: tokens),
      );
    } else {
      state = const AsyncValue.data(
        AuthState(status: AuthStatus.unAuthenticated),
      );
    }
  }
}
