import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/index.dart';
import '../../tasks.dart';
import '../../../../core/utils/index.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksNotifierProvider);

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
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist, size: 64, color: AppColors.warmGray300),
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
              ).center();
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(tasksNotifierProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onToggle: () => ref
                      .read(tasksNotifierProvider.notifier)
                      .toggleTaskCompletion(task),
                  onDelete: () => ref
                      .read(tasksNotifierProvider.notifier)
                      .deleteTask(task.id),
                );
              },
            ),
          );
        },
        loading: () => const CircularProgressIndicator().center(),
        error: (err, stack) => Text('Error: $err').center(),
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
