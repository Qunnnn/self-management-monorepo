import 'package:mobile/core/import/app_imports.dart';

class AddTaskSheet extends ConsumerWidget {
  const AddTaskSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(createTaskProvider.notifier);
    final state = ref.watch(createTaskProvider);

    ref.listen(createTaskProvider, (previous, next) {
      if (next is AsyncData && next.value == null) {
        Navigator.pop(context);
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.commonErrorPrefix(next.error.toString()))),
        );
      }
    });

    return ReactiveForm(
      formGroup: notifier.form,
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
                  context.l10n.tasksNewTask,
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
              label: context.l10n.tasksTitle,
              hintText: context.l10n.tasksTitleHint,
              autofocus: true,
              textInputAction: TextInputAction.next,
              validationMessages: {
                'required': (_) => 'Title is required',
              },
            ),
            16.h,
            ReactiveAppTextField<String>(
              formControlName: 'description',
              label: context.l10n.tasksDescription,
              hintText: context.l10n.tasksDescriptionHint,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => notifier.submit(),
            ),
            32.h,
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return AppButton(
                  text: context.l10n.tasksCreateTask,
                  isLoading: state is AsyncLoading,
                  onPressed: form.valid ? () => notifier.submit() : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
