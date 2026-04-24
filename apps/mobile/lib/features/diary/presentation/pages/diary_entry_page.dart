import 'package:mobile/core/import/app_imports.dart';

class DiaryEntryPage extends ConsumerWidget {
  final String? entryId;

  const DiaryEntryPage({super.key, this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(entryEditorProvider(entryId: entryId).notifier);
    final state = ref.watch(entryEditorProvider(entryId: entryId));

    ref.listen(entryEditorProvider(entryId: entryId), (previous, next) {
      if (next is AsyncData && next.value == null && previous is AsyncLoading) {
        Navigator.pop(context);
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(entryId != null ? 'Edit Entry' : 'New Entry'),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          if (entryId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.orange),
              onPressed: () => notifier.delete(),
            ),
        ],
      ),
      body: switch (state) {
        AsyncLoading() when !state.hasValue =>
          const CircularProgressIndicator().center(),
        AsyncError(:final error) => Text('Error: $error').center(),
        _ => ReactiveForm(
            formGroup: notifier.form,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReactiveAppTextField<String>(
                    formControlName: 'title',
                    label: 'Title',
                    hintText: 'What happened today?',
                    autofocus: true,
                    validationMessages: {
                      'required': (_) => 'Title is required',
                    },
                  ),
                  24.h,
                  Text(
                    'HOW ARE YOU FEELING?',
                    style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          color: AppColors.warmGray500,
                        ),
                  ),
                  12.h,
                  ReactiveValueListenableBuilder<DiaryMood>(
                    formControlName: 'mood',
                    builder: (context, control, child) {
                      final selectedMood = control.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: DiaryMood.values.map((mood) {
                          final isSelected = selectedMood == mood;
                          return GestureDetector(
                            onTap: () => control.value = mood,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.blue.withAlpha(20)
                                    : AppColors.warmWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.blue
                                      : AppColors.whisperBorder,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(mood.emoji,
                                      style: const TextStyle(fontSize: 24)),
                                  4.h,
                                  Text(
                                    mood.displayName,
                                    style: context.textTheme.bodySmall?.copyWith(
                                          color: isSelected
                                              ? AppColors.blue
                                              : AppColors.warmGray500,
                                          fontWeight:
                                              isSelected ? FontWeight.bold : null,
                                        ),
                                  ),
                                ],
                              ).p(12),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  24.h,
                  const ReactiveAppTextField<String>(
                    formControlName: 'content',
                    label: 'Notes',
                    hintText: 'Write down your thoughts...',
                    maxLines: 10,
                  ),
                  40.h,
                  AppButton(
                    text: 'Save Entry',
                    isLoading: state is AsyncLoading,
                    onPressed: () => notifier.save(),
                  ),
                ],
              ).p(24),
            ),
          ),
      },
    );
  }
}
