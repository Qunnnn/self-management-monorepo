import 'package:mobile/core/import/app_imports.dart';

class DiaryPage extends ConsumerWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: Text(context.l10n.diaryTitle),
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: context.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.nearBlack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(diaryProvider.notifier).refresh(),
        child: Column(
          children: [
            ReactiveForm(
              formGroup: ref.read(diaryProvider.notifier).searchForm,
              child: ReactiveAppTextField<String>(
                formControlName: AppFormControls.query,
                hintText: context.l10n.diarySearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                onChanged: (control) => ref
                    .read(diaryProvider.notifier)
                    .search(control.value ?? ''),
                decoration: InputDecoration(
                  fillColor: AppColors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.whisperBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.whisperBorder,
                    ),
                  ),
                ),
              ).px(24).py(8),
            ),
            Consumer(
              builder: (context, ref, child) {
                final diaryAsync = ref.watch(diaryProvider);
                return switch (diaryAsync) {
                  AsyncData(:final value) =>
                    value.items.isEmpty
                        ? Text(context.l10n.diaryNoEntries).center()
                        : ListView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: value.items.length,
                            itemBuilder: (context, index) {
                              final entry = value.items[index];
                              return DiaryCard(
                                entryId: entry.id,
                                onTap: () => context.push(
                                  AppRoutes.diaryEditFullPath(entry.id),
                                ),
                                onTogglePin: () => ref
                                    .read(diaryActionProvider.notifier)
                                    .togglePin(entry),
                              );
                            },
                          ),
                  AsyncError(:final error) => Text(
                    context.l10n.commonErrorPrefix(error.toString()),
                  ).center(),
                  AsyncLoading() => const CircularProgressIndicator().center(),
                };
              },
            ).expanded(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.diaryCreateFullPath),
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
