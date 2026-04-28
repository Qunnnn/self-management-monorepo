import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

enum TransactionType { income, expense }

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String userId,
    required String title,
    required double amount,
    required TransactionType type,
    required String category,
    required DateTime date,
  }) = _Transaction;
}
