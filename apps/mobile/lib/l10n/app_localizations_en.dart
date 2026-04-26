// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Self Management';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonError => 'Error';

  @override
  String get commonSuccess => 'Success';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSystem => 'System Default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get authForgotPassword => 'Forgot Password';

  @override
  String get authResetLinkSent => 'Reset link sent!';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'Enter your email';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get tasksTitle => 'Title';

  @override
  String get tasksTitleHint => 'What needs to be done?';

  @override
  String get tasksDescription => 'Description';

  @override
  String get tasksDescriptionHint => 'Optional details';

  @override
  String get financeTitle => 'Finance';

  @override
  String get financeAdd => 'Add';

  @override
  String get financeNoTransactions => 'No transactions yet';

  @override
  String get financeExpense => 'Expense';

  @override
  String get financeIncome => 'Income';

  @override
  String get financeTransactionTitle => 'Title';

  @override
  String get financeTransactionTitleHint => 'What was it for?';

  @override
  String get financeAmount => 'Amount';

  @override
  String get financeAmountHint => '0.00';

  @override
  String get financeCategory => 'Category';

  @override
  String get financeCategoryHint => 'e.g. Food, Work';

  @override
  String get diaryTitle => 'Diary';

  @override
  String get diarySearchHint => 'Search entries...';

  @override
  String get diaryNoEntries => 'No entries found';

  @override
  String get diaryEditEntry => 'Edit Entry';

  @override
  String get diaryNewEntry => 'New Entry';

  @override
  String get diaryEntryTitle => 'Title';

  @override
  String get diaryEntryTitleHint => 'What happened today?';

  @override
  String get diaryNotes => 'Notes';

  @override
  String get diaryNotesHint => 'Write down your thoughts...';

  @override
  String commonErrorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String commonErrorLoading(String message) {
    return 'Error loading: $message';
  }

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authLoginPrompt => 'Log in to your account';

  @override
  String get authLogin => 'Log In';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authEnterEmailPrompt =>
      'Enter your email and we will send you a reset link.';

  @override
  String get tasksNewTask => 'New Task';

  @override
  String get tasksCreateTask => 'Create Task';

  @override
  String get financeRecentTransactions => 'RECENT TRANSACTIONS';

  @override
  String get financeAddTransaction => 'Add Transaction';

  @override
  String get financeSaveTransaction => 'Save Transaction';

  @override
  String get diaryHowAreYouFeeling => 'HOW ARE YOU FEELING?';

  @override
  String get diarySaveEntry => 'Save Entry';
}
