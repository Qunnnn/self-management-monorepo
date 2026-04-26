import 'package:mobile/core/import/app_imports.dart';

class FinancePage extends ConsumerWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: Text(context.l10n.financeTitle),
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.nearBlack,
            ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(financeProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Consumer(
              builder: (context, ref, child) {
                final balanceAsync = ref.watch(balanceProvider);
                return switch (balanceAsync) {
                  AsyncData(:final value) => BalanceCard(balance: value),
                  AsyncLoading() => const BalanceCard(balance: 0, isLoading: true),
                  AsyncError(:final error) => Text(context.l10n.commonErrorLoading(error.toString())).center(),
                };
              },
            ),
            32.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.financeRecentTransactions,
                  style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.warmGray500,
                      ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddTransaction(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.l10n.financeAdd),
                ),
              ],
            ),
            12.h,
            Consumer(
              builder: (context, ref, child) {
                final transactionsAsync = ref.watch(financeProvider);
                return switch (transactionsAsync) {
                  AsyncData(:final value) => value.isEmpty
                      ? Text(context.l10n.financeNoTransactions)
                          .center()
                          .py(40)
                      : Column(
                          children: value
                              .map((t) => TransactionTile(transaction: t))
                              .toList(),
                        ),
                  AsyncError(:final error) => Text(context.l10n.commonErrorPrefix(error.toString())).center(),
                  AsyncLoading() => const CircularProgressIndicator()
                      .center()
                      .py(40),
                };
              },
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
