import 'package:mobile/core/import/app_imports.dart';

part 'finance_provider.g.dart';

@riverpod
class FinanceNotifier extends _$FinanceNotifier {
  @override
  FutureOr<List<Transaction>> build() async {
    return _fetchTransactions();
  }

  Future<List<Transaction>> _fetchTransactions() async {
    return await ref.read(fetchTransactionsUseCaseProvider).execute();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions());
    ref.invalidate(balanceProvider);
  }

  void updateState(List<Transaction> transactions) {
    state = AsyncValue.data(transactions);
    ref.invalidate(balanceProvider);
  }
}

@riverpod
FutureOr<double> balance(Ref ref) async {
  return await ref.read(getBalanceUseCaseProvider).execute();
}
