import '../../domain/entities/transaction.dart';
import '../models/transaction_model.dart';

class FinanceMockDataSource {
  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: '1',
      userId: 'user-1',
      title: 'Salary',
      amount: 4200.0,
      type: TransactionType.income,
      category: 'Work',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TransactionModel(
      id: '2',
      userId: 'user-1',
      title: 'Grocery Store',
      amount: 85.5,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TransactionModel(
      id: '3',
      userId: 'user-1',
      title: 'Internet Bill',
      amount: 45.0,
      type: TransactionType.expense,
      category: 'Utilities',
      date: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    TransactionModel(
      id: '4',
      userId: 'user-1',
      title: 'Freelance Project',
      amount: 1200.0,
      type: TransactionType.income,
      category: 'Work',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  Future<List<TransactionModel>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _transactions.reversed.toList();
  }

  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions.add(transaction);
    return transaction;
  }

  Future<double> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    double balance = 0;
    for (var t in _transactions) {
      if (t.type == TransactionType.income) {
        balance += t.amount;
      } else {
        balance -= t.amount;
      }
    }
    return balance;
  }
}
