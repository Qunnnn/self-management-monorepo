import 'package:mobile/core/import/app_imports.dart';
import '../providers/forgot_password/forgot_password_provider.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.read(forgotPasswordProvider.notifier).form;
    final state = ref.watch(forgotPasswordProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: ReactiveForm(
        formGroup: form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your email and we will send you a reset link.',
              textAlign: TextAlign.center,
            ),
            24.h,
            ReactiveAppTextField<String>(
              formControlName: 'email',
              label: 'Email',
              prefixIcon: const Icon(Icons.email),
              validationMessages: {
                ValidationMessage.required: (error) => 'Email is required',
                ValidationMessage.email: (error) => 'Must be a valid email',
              },
            ),
            24.h,
            AppButton(
              text: 'Send Reset Link',
              isLoading: state.isLoading,
              onPressed: () async {
                final success = await ref
                    .read(forgotPasswordProvider.notifier)
                    .submit();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reset link sent!')),
                  );
                  context.pop(); // Go back to login
                }
              },
            ),
          ],
        ).p(16),
      ),
    );
  }
}
