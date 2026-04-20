import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/main_shell.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/tasks/presentation/pages/tasks_page.dart';
import 'features/diary/presentation/pages/diary_page.dart';
import 'features/diary/presentation/pages/diary_entry_page.dart';
import 'features/finance/presentation/pages/finance_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/diary',
              builder: (context, state) => const DiaryPage(),
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (context, state) => const DiaryEntryPage(),
                ),
                GoRoute(
                  path: 'edit/:id',
                  builder: (context, state) => DiaryEntryPage(
                    entryId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/tasks',
              builder: (context, state) => const TasksPage(),
            ),
            GoRoute(
              path: '/finance',
              builder: (context, state) => const FinancePage(),
            ),
          ],
        ),
        GoRoute(
          path: '/home',
          redirect: (context, state) => '/diary',
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Self Management',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
