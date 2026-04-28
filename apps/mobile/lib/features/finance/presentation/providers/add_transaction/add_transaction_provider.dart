import 'package:mobile/core/import/app_imports.dart';

part 'add_transaction_provider.g.dart';

@riverpod
class AddTransactionNotifier extends _$AddTransactionNotifier {
  late final FormGroup form;

  @override
  FutureOr<void> build() {
    form = fb.group({
      AppFormControls.type: [TransactionType.expense, Validators.required],
      AppFormControls.title: ['', Validators.required],
      AppFormControls.amount: [
        null as double?,
        Validators.required,
        Validators.min(0.01),
      ],
      AppFormControls.category: ['', Validators.required],
    });

    ref.onDispose(form.dispose);
  }

  Future<void> submit() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    state = const AsyncValue.loading();

    final values = form.value;
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user-1',
      // Should ideally come from auth
      title: values[AppFormControls.title] as String,
      amount: values[AppFormControls.amount] as double,
      type: values[AppFormControls.type] as TransactionType,
      category: values[AppFormControls.category] as String,
      date: DateTime.now(),
    );

    try {
      final newTransaction = await ref
          .read(addTransactionUseCaseProvider)
          .execute(transaction);

      if (!ref.mounted) return;

      // Update core state
      final currentTransactions = ref.read(financeProvider).value ?? [];
      ref.read(financeProvider.notifier).updateState([
        newTransaction,
        ...currentTransactions,
      ]);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
