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
  FutureOr<AuthTokens?> build() async {
    return ref.read(tokenStorageProvider).loadTokens();
  }

  /// Manually update the authentication state.
  /// This is called by specialized providers like loginProvider or logoutProvider.
  void updateState(AuthTokens? tokens) {
    state = AsyncValue.data(tokens);
  }
}
