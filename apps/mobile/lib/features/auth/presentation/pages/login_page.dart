import 'package:mobile/core/import/app_imports.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final loginNotifier = ref.watch(loginProvider.notifier);
    final form = loginNotifier.form;
    ref.listen(loginProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.commonErrorPrefix(next.error.toString()))));
      }
    });

    ref.listen(authProvider, (previous, next) {
      final status = next.value?.status;
      if (status == AuthStatus.authenticated) {
        context.go(AppRoutes.tasks);
      }
    });

    return Scaffold(
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.authWelcomeBack,
                style: context.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              8.h,
              Text(
                context.l10n.authLoginPrompt,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.warmGray500,
                ),
                textAlign: TextAlign.center,
              ),
              48.h,
              ReactiveAppTextField<String>(
                formControlName: 'email',
                label: context.l10n.authEmail,
                hintText: context.l10n.authEmailHint,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => form.focus('password'),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Email is required',
                  ValidationMessage.email: (_) => 'Enter a valid email',
                },
              ),
              16.h,
              ReactiveAppTextField<String>(
                formControlName: 'password',
                label: context.l10n.authPassword,
                hintText: context.l10n.authPasswordHint,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _onSubmit(),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Password is required',
                  ValidationMessage.minLength: (error) =>
                      'At least ${(error as Map)['requiredLength']} characters',
                },
              ),
              24.h,
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final isLoading = ref.watch(loginProvider).isLoading;
                      return AppButton(
                        text: context.l10n.authLogin,
                        isLoading: isLoading,
                        onPressed: form.valid ? _onSubmit : null,
                      );
                    },
                  );
                },
              ),
              16.h,
              AppButton(
                text: context.l10n.authForgotPassword,
                style: AppButtonStyle.secondary,
                onPressed: () => context.push(AppRoutes.forgotPassword),
              ),
            ],
          ).p(24),
        ).center(),
      ),
    );
  }

  void _onSubmit() {
    ref.read(loginProvider.notifier).login();
  }
}
