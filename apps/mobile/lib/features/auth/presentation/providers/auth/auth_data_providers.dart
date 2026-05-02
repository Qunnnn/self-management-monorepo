import 'package:mobile/core/import/app_imports.dart';
import 'package:api_client/api_client.dart';

part 'auth_data_providers.g.dart';

@riverpod
DefaultApi publicApi(Ref ref) {
  final dio = ref.watch(dioClientProvider).publicDio;
  return DefaultApi(dio);
}

@riverpod
AuthRemoteDataSource authDataSource(Ref ref) {
  return AuthRemoteDataSource(
    ref.watch(dioClientProvider),
    ref.watch(publicApiProvider),
  );
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(authDataSourceProvider),
    ref.watch(tokenStorageProvider),
  );
}
