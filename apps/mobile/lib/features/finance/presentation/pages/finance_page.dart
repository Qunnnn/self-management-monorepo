import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/finance_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/add_transaction_sheet.dart';
import '../../../../core/utils/index.dart';

class FinancePage extends ConsumerWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(financeNotifierProvider);
    final balanceAsync = ref.watch(balanceProvider);

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: const Text('Finance'),
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.nearBlack,
            ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(financeNotifierProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            balanceAsync.when(
              data: (balance) => BalanceCard(balance: balance),
              loading: () => const BalanceCard(balance: 0, isLoading: true),
              error: (err, _) => Text('Error loading balance: $err').center(),
            ),
            32.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECENT TRANSACTIONS',
                  style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.warmGray500,
                      ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddTransaction(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            12.h,
            transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Text('No transactions yet')
                      .center()
                      .py(40);
                }
                return Column(
                  children: transactions
                      .map((t) => TransactionTile(transaction: t))
                      .toList(),
                );
              },
              loading: () => const CircularProgressIndicator()
                  .center()
                  .py(40),
              error: (err, _) => Text('Error: $err').center(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransaction(context),
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }
}
