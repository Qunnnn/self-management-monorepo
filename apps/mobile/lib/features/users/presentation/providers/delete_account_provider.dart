import 'package:mobile/core/import/app_imports.dart';

part 'delete_account_provider.g.dart';

@riverpod
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    final result = await ref.read(userRepositoryProvider).deleteAccount();

    result.match(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        ref.read(authProvider.notifier).updateState(null);
        state = const AsyncValue.data(null);
      },
    );
  }
}
