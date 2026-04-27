import 'package:mobile/core/import/app_imports.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final preferences = ref.watch(preferencesProvider);

    return ReactiveFormConfig(
      validationMessages: {
        ValidationMessage.required: (error) => context.l10n.validationRequiredGeneric,
        ValidationMessage.email: (error) => context.l10n.validationEmailGeneric,
        ValidationMessage.minLength: (error) => context.l10n.validationMinLengthGeneric,
        ValidationMessage.maxLength: (error) => context.l10n.validationMaxLengthGeneric,
        ValidationMessage.number: (error) => context.l10n.validationNumberGeneric,
        ValidationMessage.min: (error) => context.l10n.validationMinGeneric,
      },
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: preferences.localeCode != null ? Locale(preferences.localeCode!) : null,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: preferences.themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
