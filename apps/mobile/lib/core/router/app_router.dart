import 'package:mobile/core/import/app_imports.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final status = authState.value?.status ?? AuthStatus.initial;

      // If still loading or initial, don't redirect yet
      if (status == AuthStatus.initial) return null;

      final isAuthRoute =
          state.uri.path == AppRoutes.login ||
          state.uri.path == AppRoutes.forgotPassword;

      if (status == AuthStatus.unAuthenticated) {
        // If not authenticated, force them to login unless they are already there
        return isAuthRoute ? null : AppRoutes.login;
      }

      if (status == AuthStatus.authenticated) {
        // If authenticated, don't allow them to stay on the auth pages
        return isAuthRoute ? AppRoutes.tasks : null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.diary,
                builder: (context, state) => const DiaryPage(),
                routes: [
                  GoRoute(
                    path: AppRoutes.diaryCreate,
                    builder: (context, state) => const DiaryEntryPage(),
                  ),
                  GoRoute(
                    path: AppRoutes.diaryEdit,
                    builder: (context, state) =>
                        DiaryEntryPage(entryId: state.pathParameters['id']),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) => const TasksPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.finance,
                builder: (context, state) => const FinancePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.home,
        redirect: (context, state) => AppRoutes.diary,
      ),
    ],
  );
}
