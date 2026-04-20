import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/diary_entry.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;

  const DiaryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE, MMM d');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isPinned ? AppColors.blue.withAlpha(50) : AppColors.whisperBorder,
          width: entry.isPinned ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormatter.format(entry.createdAt).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          color: AppColors.warmGray500,
                        ),
                  ),
                  Row(
                    children: [
                      if (entry.mood != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            entry.mood!.emoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      GestureDetector(
                        onTap: onTogglePin,
                        child: Icon(
                          entry.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                          size: 16,
                          color: entry.isPinned ? AppColors.blue : AppColors.warmGray300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entry.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.nearBlack,
                    ),
              ),
              if (entry.content.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  entry.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.warmGray600,
                        height: 1.4,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
