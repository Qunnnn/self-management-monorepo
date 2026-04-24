import 'package:mobile/core/import/app_imports.dart';

part 'forgot_password_provider.g.dart';

@riverpod
class ForgotPasswordNotifier extends _$ForgotPasswordNotifier {
  late final FormGroup form;

  @override
  FutureOr<void> build() {
    form = fb.group({
      'email': ['', Validators.required, Validators.email],
    });

    ref.onDispose(form.dispose);
  }

  Future<bool> submit() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return false;
    }

    state = const AsyncValue.loading();
    try {
      // final email = form.control('email').value as String;
      
      // TODO: Call repo.forgotPassword(email)
      await Future.delayed(const Duration(seconds: 1));
      
      state = const AsyncValue.data(null);
      return true; // Success
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
