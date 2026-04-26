import 'package:mobile/core/import/app_imports.dart';

class AddTransactionSheet extends ConsumerWidget {
  const AddTransactionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addTransactionProvider.notifier);
    final state = ref.watch(addTransactionProvider);

    ref.listen(addTransactionProvider, (previous, next) {
      if (next is AsyncData && next.value == null && previous is AsyncLoading) {
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
            Text(
              context.l10n.financeAddTransaction,
              style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            24.h,
            ReactiveValueListenableBuilder<TransactionType>(
              formControlName: 'type',
              builder: (context, control, child) {
                final type = control.value;
                return Row(
                  children: [
                    _TypeButton(
                      label: context.l10n.financeExpense,
                      isSelected: type == TransactionType.expense,
                      onTap: () => control.value = TransactionType.expense,
                      color: AppColors.orange,
                    ).expanded(),
                    12.w,
                    _TypeButton(
                      label: context.l10n.financeIncome,
                      isSelected: type == TransactionType.income,
                      onTap: () => control.value = TransactionType.income,
                      color: AppColors.teal,
                    ).expanded(),
                  ],
                );
              },
            ),
            24.h,
            ReactiveAppTextField<String>(
              formControlName: 'title',
              label: context.l10n.financeTransactionTitle,
              hintText: context.l10n.financeTransactionTitleHint,
              autofocus: true,
              textInputAction: TextInputAction.next,
              validationMessages: {
                'required': (_) => 'Title is required',
              },
            ),
            16.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveAppTextField<double>(
                  formControlName: 'amount',
                  label: context.l10n.financeAmount,
                  hintText: context.l10n.financeAmountHint,
                  keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validationMessages: {
                    'required': (_) => 'Required',
                    'min': (_) => 'Must be > 0',
                  },
                ).expanded(2),
                16.w,
                ReactiveAppTextField<String>(
                  formControlName: 'category',
                  label: context.l10n.financeCategory,
                  hintText: context.l10n.financeCategoryHint,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => notifier.submit(),
                  validationMessages: {
                    'required': (_) => 'Required',
                  },
                ).expanded(3),
              ],
            ),
            32.h,
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return AppButton(
                  text: context.l10n.financeSaveTransaction,
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

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.warmWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColors.whisperBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.warmGray500,
              ),
        ),
      ),
    );
  }
}
