import 'package:mobile/core/import/app_imports.dart';

part 'logout_provider.g.dart';

@riverpod
class LogoutNotifier extends _$LogoutNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final result = await ref.read(authRepositoryProvider).logout();

    if (!ref.mounted) return;
    
    state = result.match(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) {
        ref.read(authProvider.notifier).updateState(null);
        return const AsyncValue.data(null);
      },
    );
  }
}
