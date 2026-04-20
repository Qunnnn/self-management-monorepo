import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/index.dart';
import '../providers/tasks_provider.dart';
import '../../../../core/utils/index.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final form = fb.group({
    'title': ['', Validators.required],
    'description': [''],
  });
  bool _isLoading = false;

  Future<void> _submit() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final values = form.value;
      await ref.read(tasksNotifierProvider.notifier).addTask(
            values['title'] as String,
            (values['description'] as String?)?.isEmpty ?? true
                ? null
                : values['description'] as String,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Task',
                  style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppColors.warmGray300,
                ),
              ],
            ),
            24.h,
            ReactiveAppTextField<String>(
              formControlName: 'title',
              label: 'Title',
              hintText: 'What needs to be done?',
              autofocus: true,
              textInputAction: TextInputAction.next,
              validationMessages: {
                ValidationMessage.required: (_) => 'Title is required',
              },
            ),
            16.h,
            ReactiveAppTextField<String>(
              formControlName: 'description',
              label: 'Description',
              hintText: 'Optional details',
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            32.h,
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return AppButton(
                  text: 'Create Task',
                  isLoading: _isLoading,
                  onPressed: form.valid ? _submit : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
