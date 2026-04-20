import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finance_repository.dart';
import '../data_sources/finance_mock_data_source.dart';
import '../models/transaction_model.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceMockDataSource _dataSource;

  FinanceRepositoryImpl(this._dataSource);

  @override
  Future<List<Transaction>> getTransactions({int? limit, int? offset}) async {
    final models = await _dataSource.getTransactions(limit: limit, offset: offset);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    final result = await _dataSource.addTransaction(model);
    return result.toEntity();
  }

  @override
  Future<double> getBalance() async {
    return await _dataSource.getBalance();
  }
}
