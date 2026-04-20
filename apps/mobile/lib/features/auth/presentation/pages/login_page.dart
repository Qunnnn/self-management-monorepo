import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';
import '../../../../core/utils/index.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

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
      body: SingleChildScrollView(
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
            AppTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            16.h,
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
            ),
            24.h,
            AppButton(
              text: 'Log In',
              isLoading: authState.isLoading,
              onPressed: () {
                ref.read(authNotifierProvider.notifier).login(
                      _emailController.text,
                      _passwordController.text,
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
    );
  }
}
