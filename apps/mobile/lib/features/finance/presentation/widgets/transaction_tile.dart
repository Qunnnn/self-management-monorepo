import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/transaction.dart';
import '../../../../core/utils/index.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, yyyy');
    final isIncome = transaction.type == TransactionType.income;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.whisperBorder),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isIncome
                  ? AppColors.teal.withAlpha(20)
                  : AppColors.orange.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.south_west : Icons.north_east,
              color: isIncome ? AppColors.teal : AppColors.orange,
              size: 20,
            ).p(8),
          ),
          16.w,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.nearBlack,
                ),
              ),
              Text(
                '${transaction.category} • ${dateFormatter.format(transaction.date)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.warmGray500,
                ),
              ),
            ],
          ).expanded(),
          Text(
            '${isIncome ? '+' : '-'}${currencyFormatter.format(transaction.amount)}',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isIncome ? AppColors.teal : AppColors.orange,
            ),
          ),
        ],
      ).px(16).py(12),
    );
  }
}
