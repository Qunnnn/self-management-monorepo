import '../entities/transaction.dart';

abstract class FinanceRepository {
  Future<List<Transaction>> getTransactions({int? limit, int? offset});

  Future<Transaction> addTransaction(Transaction transaction);

  Future<double> getBalance();
}
