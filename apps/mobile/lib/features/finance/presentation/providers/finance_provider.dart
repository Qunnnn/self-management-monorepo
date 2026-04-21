import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/data_sources/finance_mock_data_source.dart';
import '../../data/repositories/finance_repository_impl.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';
import '../../domain/use_cases/finance_use_cases.dart';

part 'finance_provider.g.dart';

@riverpod
FinanceMockDataSource financeDataSource(Ref ref) {
  return FinanceMockDataSource();
}

@riverpod
FinanceRepository financeRepository(Ref ref) {
  return FinanceRepositoryImpl(ref.watch(financeDataSourceProvider));
}

@riverpod
FetchTransactionsUseCase fetchTransactionsUseCase(Ref ref) {
  return FetchTransactionsUseCase(ref.watch(financeRepositoryProvider));
}

@riverpod
AddTransactionUseCase addTransactionUseCase(Ref ref) {
  return AddTransactionUseCase(ref.watch(financeRepositoryProvider));
}

@riverpod
GetBalanceUseCase getBalanceUseCase(Ref ref) {
  return GetBalanceUseCase(ref.watch(financeRepositoryProvider));
}

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

  Future<void> addTransaction(Transaction transaction) async {
    final newTransaction =
        await ref.read(addTransactionUseCaseProvider).execute(transaction);

    if (!ref.mounted) return;
    state.whenData((transactions) {
      state = AsyncValue.data([newTransaction, ...transactions]);
    });
    ref.invalidate(balanceProvider);
  }
}

@riverpod
FutureOr<double> balance(Ref ref) async {
  return await ref.read(getBalanceUseCaseProvider).execute();
}
