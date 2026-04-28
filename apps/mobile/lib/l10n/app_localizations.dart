import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Self Management'**
  String get appTitle;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotPassword;

  /// No description provided for @authResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent!'**
  String get authResetLinkSent;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tasksTitle;

  /// No description provided for @tasksTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done?'**
  String get tasksTitleHint;

  /// No description provided for @tasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tasksDescription;

  /// No description provided for @tasksDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional details'**
  String get tasksDescriptionHint;

  /// No description provided for @financeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeTitle;

  /// No description provided for @financeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get financeAdd;

  /// No description provided for @financeNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get financeNoTransactions;

  /// No description provided for @financeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeExpense;

  /// No description provided for @financeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeIncome;

  /// No description provided for @financeTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get financeTransactionTitle;

  /// No description provided for @financeTransactionTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What was it for?'**
  String get financeTransactionTitleHint;

  /// No description provided for @financeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get financeAmount;

  /// No description provided for @financeAmountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get financeAmountHint;

  /// No description provided for @financeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get financeCategory;

  /// No description provided for @financeCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Food, Work'**
  String get financeCategoryHint;

  /// No description provided for @diaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diaryTitle;

  /// No description provided for @diarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search entries...'**
  String get diarySearchHint;

  /// No description provided for @diaryNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries found'**
  String get diaryNoEntries;

  /// No description provided for @diaryEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get diaryEditEntry;

  /// No description provided for @diaryNewEntry.
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get diaryNewEntry;

  /// No description provided for @diaryEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get diaryEntryTitle;

  /// No description provided for @diaryEntryTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What happened today?'**
  String get diaryEntryTitleHint;

  /// No description provided for @diaryNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get diaryNotes;

  /// No description provided for @diaryNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Write down your thoughts...'**
  String get diaryNotesHint;

  /// No description provided for @commonErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String commonErrorPrefix(String message);

  /// No description provided for @commonErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading: {message}'**
  String commonErrorLoading(String message);

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get authLoginPrompt;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLogin;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authEnterEmailPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you a reset link.'**
  String get authEnterEmailPrompt;

  /// No description provided for @tasksNewTask.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get tasksNewTask;

  /// No description provided for @tasksCreateTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get tasksCreateTask;

  /// No description provided for @financeRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'RECENT TRANSACTIONS'**
  String get financeRecentTransactions;

  /// No description provided for @financeAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get financeAddTransaction;

  /// No description provided for @financeSaveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get financeSaveTransaction;

  /// No description provided for @diaryHowAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'HOW ARE YOU FEELING?'**
  String get diaryHowAreYouFeeling;

  /// No description provided for @diarySaveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Entry'**
  String get diarySaveEntry;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationRequired(String field);

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid {field}'**
  String validationEmail(String field);

  /// No description provided for @validationMinLength.
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {count} characters'**
  String validationMinLength(String field, String count);

  /// No description provided for @validationMaxLength.
  ///
  /// In en, this message translates to:
  /// **'{field} must be at most {count} characters'**
  String validationMaxLength(String field, String count);

  /// No description provided for @validationNumber.
  ///
  /// In en, this message translates to:
  /// **'{field} must be a number'**
  String validationNumber(String field);

  /// No description provided for @validationMin.
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {value}'**
  String validationMin(String field, String value);

  /// No description provided for @validationRequiredGeneric.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequiredGeneric;

  /// No description provided for @validationEmailGeneric.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get validationEmailGeneric;

  /// No description provided for @validationMinLengthGeneric.
  ///
  /// In en, this message translates to:
  /// **'Value is too short'**
  String get validationMinLengthGeneric;

  /// No description provided for @validationMaxLengthGeneric.
  ///
  /// In en, this message translates to:
  /// **'Value is too long'**
  String get validationMaxLengthGeneric;

  /// No description provided for @validationNumberGeneric.
  ///
  /// In en, this message translates to:
  /// **'Must be a number'**
  String get validationNumberGeneric;

  /// No description provided for @validationMinGeneric.
  ///
  /// In en, this message translates to:
  /// **'Value is too small'**
  String get validationMinGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
