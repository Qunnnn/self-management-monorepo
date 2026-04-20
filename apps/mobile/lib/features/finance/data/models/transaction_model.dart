import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  factory TransactionModel.fromEntity(Transaction entity) => TransactionModel(
        id: entity.id,
        userId: entity.userId,
        title: entity.title,
        amount: entity.amount,
        type: entity.type,
        category: entity.category,
        date: entity.date,
      );

  Transaction toEntity() => Transaction(
        id: id,
        userId: userId,
        title: title,
        amount: amount,
        type: type,
        category: category,
        date: date,
      );
}
