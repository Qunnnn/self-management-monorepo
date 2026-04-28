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
          SnackBar(
            content: Text(
              context.l10n.commonErrorPrefix(next.error.toString()),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          entryId != null
              ? context.l10n.diaryEditEntry
              : context.l10n.diaryNewEntry,
        ),
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
        AsyncError(:final error) => Text(
          context.l10n.commonErrorPrefix(error.toString()),
        ).center(),
        _ => ReactiveForm(
          formGroup: notifier.form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveAppTextField<String>(
                  formControlName: AppFormControls.title,
                  label: context.l10n.diaryEntryTitle,
                  hintText: context.l10n.diaryEntryTitleHint,
                  autofocus: true,
                ),
                24.h,
                Text(
                  context.l10n.diaryHowAreYouFeeling,
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: AppColors.warmGray500,
                  ),
                ),
                12.h,
                ReactiveValueListenableBuilder<DiaryMood>(
                  formControlName: DiaryFormControls.mood,
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
                                Text(
                                  mood.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                4.h,
                                Text(
                                  mood.displayName,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: isSelected
                                        ? AppColors.blue
                                        : AppColors.warmGray500,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : null,
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
                ReactiveAppTextField<String>(
                  formControlName: DiaryFormControls.content,
                  label: context.l10n.diaryNotes,
                  hintText: context.l10n.diaryNotesHint,
                  maxLines: 10,
                ),
                40.h,
                AppButton(
                  text: context.l10n.diarySaveEntry,
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
