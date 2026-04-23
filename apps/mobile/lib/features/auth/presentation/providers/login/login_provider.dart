import 'package:mobile/core/import/app_imports.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  late final FormGroup form;

  @override
  FutureOr<void> build() {
    form = fb.group({
      'email': ['', Validators.required, Validators.email],
      'password': ['', Validators.required, Validators.minLength(6)],
    });

    ref.onDispose(form.dispose);
  }

  Future<void> login() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    state = const AsyncValue.loading();
    final result = await ref.read(loginUseCaseProvider).execute(
      email: form.control('email').value as String,
      password: form.control('password').value as String,
    );

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
