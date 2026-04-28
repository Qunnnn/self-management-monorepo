import 'package:mobile/core/import/app_imports.dart';

class DiaryCard extends ConsumerWidget {
  final String entryId;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;

  const DiaryCard({
    super.key,
    required this.entryId,
    required this.onTap,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(
      diaryProvider.select(
        (s) => s.value?.items.firstWhereOrNull((e) => e.id == entryId),
      ),
    );
    if (entry == null) return const SizedBox.shrink();

    final dateFormatter = DateFormat('EEEE, MMM d');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isPinned
              ? AppColors.blue.withAlpha(50)
              : AppColors.whisperBorder,
          width: entry.isPinned ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormatter.format(entry.createdAt).toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: AppColors.warmGray500,
                  ),
                ),
                Row(
                  children: [
                    if (entry.mood != null)
                      Text(
                        entry.mood!.emoji,
                        style: const TextStyle(fontSize: 16),
                      ).pr(8),
                    GestureDetector(
                      onTap: onTogglePin,
                      child: Icon(
                        entry.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        size: 16,
                        color: entry.isPinned
                            ? AppColors.blue
                            : AppColors.warmGray300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            12.h,
            Text(
              entry.title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.nearBlack,
              ),
            ),
            if (entry.content.isNotEmpty) ...[
              4.h,
              Text(
                entry.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.warmGray600,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ).p(16),
      ),
    );
  }
}
