import '../entities/transaction.dart';
import '../repositories/finance_repository.dart';

class FetchTransactionsUseCase {
  final FinanceRepository _repository;

  FetchTransactionsUseCase(this._repository);

  Future<List<Transaction>> execute({
    int? limit,
    int? offset,
  }) async {
    return await _repository.getTransactions(
      limit: limit,
      offset: offset,
    );
  }
}

class AddTransactionUseCase {
  final FinanceRepository _repository;

  AddTransactionUseCase(this._repository);

  Future<Transaction> execute(Transaction transaction) async {
    return await _repository.addTransaction(transaction);
  }
}

class GetBalanceUseCase {
  final FinanceRepository _repository;

  GetBalanceUseCase(this._repository);

  Future<double> execute() async {
    return await _repository.getBalance();
  }
}
