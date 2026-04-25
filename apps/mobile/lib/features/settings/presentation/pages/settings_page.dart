import 'package:mobile/core/import/app_imports.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(context.l10n.settingsTheme),
            trailing: DropdownButton<ThemeMode>(
              value: prefs.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(preferencesProvider.notifier).setThemeMode(mode);
                }
              },
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(context.l10n.themeSystem)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(context.l10n.themeLight)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(context.l10n.themeDark)),
              ],
            ),
          ),
          ListTile(
            title: Text(context.l10n.settingsLanguage),
            trailing: DropdownButton<String?>(
              value: prefs.localeCode,
              onChanged: (code) {
                ref.read(preferencesProvider.notifier).setLocaleCode(code);
              },
              items: [
                DropdownMenuItem(value: null, child: Text(context.l10n.languageSystem)),
                DropdownMenuItem(value: 'en', child: Text(context.l10n.languageEnglish)),
                DropdownMenuItem(value: 'vi', child: Text(context.l10n.languageVietnamese)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
