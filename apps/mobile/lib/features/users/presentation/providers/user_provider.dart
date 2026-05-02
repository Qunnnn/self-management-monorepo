import 'package:mobile/core/import/app_imports.dart';
import 'package:api_client/api_client.dart' hide User;

part 'user_provider.g.dart';

@riverpod
DefaultApi protectedApi(Ref ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return DefaultApi(dio);
}

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
    ref.watch(protectedApiProvider),
  );
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));
}

@riverpod
FutureOr<User?> currentUser(Ref ref) async {
  final authState = ref.watch(authProvider);

  return switch (authState) {
    AsyncData(:final value) => await _fetchUser(ref, value),
    _ => null,
  };
}

Future<User?> _fetchUser(Ref ref, AuthState state) async {
  if (state.tokens == null) return null;
  final result = await ref.read(userRepositoryProvider).fetchCurrentUser();
  return result.match((failure) => null, (user) => user);
}
