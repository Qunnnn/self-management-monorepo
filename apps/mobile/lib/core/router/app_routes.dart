class AppRoutes {
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const settings = '/settings';
  static const home = '/home';

  static const diary = '/diary';
  static const diaryCreate = 'create';
  static const diaryEdit = 'edit/:id';

  static const tasks = '/tasks';
  static const finance = '/finance';

  // Full paths for navigation
  static const diaryFullPath = diary;
  static const diaryCreateFullPath = '$diary/$diaryCreate';
  static String diaryEditFullPath(String id) => '$diary/edit/$id';
}
