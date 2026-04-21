import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/index.dart';
import '../../tasks.dart';
import '../../../../core/utils/index.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: context.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.nearBlack,
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddTask(context),
            icon: const Icon(Icons.add_circle, color: AppColors.blue, size: 28),
          ),
          12.w,
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final tasksAsync = ref.watch(tasksProvider);
          return switch (tasksAsync) {
            AsyncData(:final value) =>
              value.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checklist,
                          size: 64,
                          color: AppColors.warmGray300,
                        ),
                        16.h,
                        Text(
                          'No tasks yet',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: AppColors.warmGray500,
                          ),
                        ),
                        8.h,
                        TextButton(
                          onPressed: () => _showAddTask(context),
                          child: const Text('Add your first task'),
                        ),
                      ],
                    ).center()
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(tasksProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          final task = value[index];
                          return TaskCard(
                            taskId: task.id,
                            onToggle: () => ref
                                .read(tasksProvider.notifier)
                                .toggleTaskCompletion(task),
                            onDelete: () => ref
                                .read(tasksProvider.notifier)
                                .deleteTask(task.id),
                          );
                        },
                      ),
                    ),
            AsyncError(:final error) => Text('Error: $error').center(),
            AsyncLoading() => const CircularProgressIndicator().center(),
          };
        },
      ),
    );
  }

  void _showAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskSheet(),
    );
  }
}
