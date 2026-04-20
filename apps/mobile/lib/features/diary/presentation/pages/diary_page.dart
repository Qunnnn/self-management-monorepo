import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/diary_provider.dart';
import '../widgets/diary_card.dart';
import '../../../../core/utils/index.dart';

class DiaryPage extends ConsumerWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(diaryNotifierProvider);

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
        onRefresh: () => ref.read(diaryNotifierProvider.notifier).refresh(),
        child: Column(
          children: [
            TextField(
              onChanged: (value) =>
                  ref.read(diaryNotifierProvider.notifier).search(value),
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
            entriesAsync.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return const Text('No entries found').center();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return DiaryCard(
                      entry: entry,
                      onTap: () => context.push('/diary/edit/${entry.id}'),
                      onTogglePin: () => ref
                          .read(diaryNotifierProvider.notifier)
                          .togglePin(entry),
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator().center(),
              error: (err, _) => Text('Error: $err').center(),
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
