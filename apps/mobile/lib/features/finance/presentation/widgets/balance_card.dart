import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/index.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final bool isLoading;

  const BalanceCard({super.key, required this.balance, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.whisperBorder),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: AppColors.warmGray500,
            ),
          ),
          8.h,
          if (isLoading)
            const LinearProgressIndicator(
              backgroundColor: AppColors.warmWhite,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
            ).center().h(48)
          else
            Text(
              currencyFormatter.format(balance),
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.nearBlack,
                letterSpacing: -1.0,
              ),
            ),
        ],
      ).p(24),
    );
  }
}
