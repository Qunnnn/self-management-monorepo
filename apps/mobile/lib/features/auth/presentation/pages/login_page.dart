import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/index.dart';
import '../providers/auth_provider.dart';
import '../../../../core/utils/index.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final form = fb.group({
    'email': ['', Validators.required, Validators.email],
    'password': ['', Validators.required, Validators.minLength(6)],
  });

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      } else if (next.hasValue && next.value != null) {
        context.go('/tasks');
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
                'Welcome Back',
                style: context.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              8.h,
              Text(
                'Log in to your account',
                style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.warmGray500,
                    ),
                textAlign: TextAlign.center,
              ),
              48.h,
              ReactiveAppTextField<String>(
                formControlName: 'email',
                label: 'Email',
                hintText: 'Enter your email',
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
                label: 'Password',
                hintText: 'Enter your password',
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
                      final isLoading = ref.watch(
                        authNotifierProvider.select((s) => s.isLoading),
                      );
                      return AppButton(
                        text: 'Log In',
                        isLoading: isLoading,
                        onPressed: form.valid ? _onSubmit : null,
                      );
                    },
                  );
                },
              ),
              16.h,
              AppButton(
                text: 'Forgot password?',
                style: AppButtonStyle.secondary,
                onPressed: () {},
              ),
            ],
          ).p(24),
        ).center(),
      ),
    );
  }

  void _onSubmit() {
    if (form.valid) {
      ref.read(authNotifierProvider.notifier).login(
            form.control('email').value as String,
            form.control('password').value as String,
          );
    } else {
      form.markAllAsTouched();
    }
  }
}
