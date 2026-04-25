import 'package:mobile/core/import/app_imports.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final status = authState.value?.status ?? AuthStatus.initial;

      // If still loading or initial, don't redirect yet
      if (status == AuthStatus.initial) return null;

      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/forgot-password';

      if (status == AuthStatus.unAuthenticated) {
        // If not authenticated, force them to login unless they are already there
        return isAuthRoute ? null : '/login';
      }

      if (status == AuthStatus.authenticated) {
        // If authenticated, don't allow them to stay on the auth pages
        return isAuthRoute ? '/tasks' : null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
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
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/finance',
                builder: (context, state) => const FinancePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        redirect: (context, state) => '/diary',
      ),
    ],
  );
}
