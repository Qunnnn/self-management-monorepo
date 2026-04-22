import 'package:mobile/core/import/app_imports.dart';

class DiaryPage extends ConsumerWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: const Text('Diary'),
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.nearBlack,
            ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(diaryProvider.notifier).refresh(),
        child: Column(
          children: [
            TextField(
              onChanged: (value) =>
                  ref.read(diaryProvider.notifier).search(value),
              decoration: InputDecoration(
                hintText: 'Search entries...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                fillColor: AppColors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.whisperBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.whisperBorder),
                ),
              ),
            ).px(24).py(8),
            Consumer(
              builder: (context, ref, child) {
                final entriesAsync = ref.watch(diaryProvider);
                return switch (entriesAsync) {
                  AsyncData(:final value) => value.isEmpty
                      ? const Text('No entries found').center()
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final entry = value[index];
                            return DiaryCard(
                              entryId: entry.id,
                              onTap: () => context.push('/diary/edit/${entry.id}'),
                              onTogglePin: () => ref
                                  .read(diaryProvider.notifier)
                                  .togglePin(entry),
                            );
                          },
                        ),
                  AsyncError(:final error) => Text('Error: $error').center(),
                  AsyncLoading() => const CircularProgressIndicator().center(),
                };
              },
            ).expanded(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/diary/create'),
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
