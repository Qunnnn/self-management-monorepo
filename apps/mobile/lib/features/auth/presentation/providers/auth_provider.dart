import 'package:mobile/core/import/app_imports.dart';

part 'auth_provider.g.dart';

@riverpod
AuthApi authApi(Ref ref) {
  final dio = ref.watch(dioClientProvider).publicDio;
  return AuthApi(dio);
}

@riverpod
AuthRemoteDataSource authDataSource(Ref ref) {
  return AuthRemoteDataSource(
    ref.watch(dioClientProvider),
    ref.watch(authApiProvider),
  );
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(authDataSourceProvider),
    ref.watch(tokenStorageProvider),
  );
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

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
