import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/core/network/index.dart';
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
