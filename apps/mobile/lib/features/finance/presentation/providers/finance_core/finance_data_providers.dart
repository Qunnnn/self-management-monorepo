import 'package:mobile/core/import/app_imports.dart';

part 'finance_data_providers.g.dart';

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
