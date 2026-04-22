import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/index.dart';
import '../../data/data_sources/auth_api.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/presentation/providers/user_provider.dart';

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
    ref.watch(userRepositoryProvider),
  );
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(loginUseCaseProvider)
        .execute(email: email, password: password);

    if (!ref.mounted) return;
    state = result.match(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (data) {
        final (user, _) = data;
        return AsyncValue.data(user);
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final result = await ref.read(authRepositoryProvider).logout();

    if (!ref.mounted) return;
    state = result.match(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }
}
