import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../../core/theme/index.dart';
import '../../tasks.dart';
import '../../../../core/utils/index.dart';
import '../providers/tasks_provider.dart';

class TaskCard extends ConsumerWidget {
  final String taskId;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.taskId,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(
      tasksNotifierProvider.select(
        (s) => s.value?.firstWhereOrNull((t) => t.id == taskId),
      ),
    );
    if (task == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.whisperBorder),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDelete?.call(),
          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.red.shade400,
            child: const Icon(Icons.delete_outline, color: AppColors.white),
          ).px(20),
          child: InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      key: ValueKey(task.isCompleted),
                      color: task.isCompleted
                          ? AppColors.green
                          : AppColors.warmGray300,
                      size: 26,
                    ),
                  ),
                  16.w,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          task.title,
                          style: context.textTheme.titleMedium?.copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? AppColors.warmGray300
                                    : AppColors.nearBlack,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        if (task.description != null &&
                            task.description!.isNotEmpty) ...[
                          4.h,
                          Text(
                            task.description!,
                            style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.warmGray500,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ).expanded(),
                  if (task.isCompleted)
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.orange,
                      size: 16,
                    ),
                ],
              ).p(16),
            ),
        ),
      ),
    );
  }
}
