import 'package:mobile/core/import/app_imports.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(loginUseCaseProvider)
        .execute(email: email, password: password);

    if (!ref.mounted) return;
    
    state = result.match(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (tokens) {
        ref.read(authProvider.notifier).updateState(tokens);
        return const AsyncValue.data(null);
      },
    );
  }
}
