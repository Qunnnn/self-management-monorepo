import 'package:mobile/core/import/app_imports.dart';
import '../providers/forgot_password/forgot_password_provider.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.read(forgotPasswordProvider.notifier).form;
    final state = ref.watch(forgotPasswordProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.authForgotPassword)),
      body: ReactiveForm(
        formGroup: form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.authEnterEmailPrompt,
              textAlign: TextAlign.center,
            ),
            24.h,
            ReactiveAppTextField<String>(
              formControlName: AppFormControls.email,
              label: context.l10n.authEmail,
              prefixIcon: const Icon(Icons.email),
            ),
            24.h,
            AppButton(
              text: context.l10n.authSendResetLink,
              isLoading: state.isLoading,
              onPressed: () async {
                final success = await ref
                    .read(forgotPasswordProvider.notifier)
                    .submit();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.authResetLinkSent)),
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
