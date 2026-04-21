import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/transaction.dart';
import '../providers/finance_provider.dart';
import '../../../../core/utils/index.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  late FormGroup form;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    form = fb.group({
      'type': [TransactionType.expense, Validators.required],
      'title': ['', Validators.required],
      'amount': [
        null as double?,
        Validators.required,
        Validators.min(0.01),
      ],
      'category': ['', Validators.required],
    });
  }

  Future<void> _submit() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final values = form.value;
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user-1',
        title: values['title'] as String,
        amount: values['amount'] as double,
        type: values['type'] as TransactionType,
        category: values['category'] as String,
        date: DateTime.now(),
      );

      await ref.read(financeProvider.notifier).addTransaction(transaction);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add transaction: $e')),
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
            Text(
              'Add Transaction',
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
                      label: 'Expense',
                      isSelected: type == TransactionType.expense,
                      onTap: () => control.value = TransactionType.expense,
                      color: AppColors.orange,
                    ).expanded(),
                    12.w,
                    _TypeButton(
                      label: 'Income',
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
              label: 'Title',
              hintText: 'What was it for?',
              autofocus: true,
              textInputAction: TextInputAction.next,
              validationMessages: {
                ValidationMessage.required: (_) => 'Title is required',
              },
            ),
            16.h,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveAppTextField<double>(
                  formControlName: 'amount',
                  label: 'Amount',
                  hintText: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Required',
                    ValidationMessage.min: (_) => 'Must be > 0',
                  },
                ).expanded(2),
                16.w,
                ReactiveAppTextField<String>(
                  formControlName: 'category',
                  label: 'Category',
                  hintText: 'e.g. Food, Work',
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Required',
                  },
                ).expanded(3),
              ],
            ),
            32.h,
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return AppButton(
                  text: 'Save Transaction',
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
