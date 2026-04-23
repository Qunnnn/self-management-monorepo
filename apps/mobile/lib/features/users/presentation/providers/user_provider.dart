import 'package:mobile/core/import/app_imports.dart';
import 'package:mobile/features/users/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/users/data/data_sources/user_api.dart';
import 'package:mobile/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:mobile/features/users/data/repositories/user_repository_impl.dart';
import 'package:mobile/features/users/domain/repositories/user_repository.dart';

part 'user_provider.g.dart';

@riverpod
UserApi userApi(Ref ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return UserApi(dio);
}

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSourceImpl(
    ref.watch(dioClientProvider),
    ref.watch(userApiProvider),
  );
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));
}

@riverpod
FutureOr<User?> currentUser(Ref ref) async {
  final authState = ref.watch(authProvider);

  return authState.when(
    data: (tokens) async {
      if (tokens == null) return null;
      final result = await ref.read(userRepositoryProvider).fetchCurrentUser();
      return result.match(
        (failure) => null,
        (user) => user,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
}
