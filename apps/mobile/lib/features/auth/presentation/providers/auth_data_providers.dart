import 'package:mobile/core/import/app_imports.dart';

part 'auth_data_providers.g.dart';

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
