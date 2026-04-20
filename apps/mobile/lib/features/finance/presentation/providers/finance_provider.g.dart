// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$financeDataSourceHash() => r'49ef2a9cfdead227584b9bf60cc92bf593d3b646';

/// See also [financeDataSource].
@ProviderFor(financeDataSource)
final financeDataSourceProvider =
    AutoDisposeProvider<FinanceMockDataSource>.internal(
      financeDataSource,
      name: r'financeDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$financeDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FinanceDataSourceRef = AutoDisposeProviderRef<FinanceMockDataSource>;
String _$financeRepositoryHash() => r'7e95934fa6e7cd64970ed7bd4f811df70e599e6b';

/// See also [financeRepository].
@ProviderFor(financeRepository)
final financeRepositoryProvider =
    AutoDisposeProvider<FinanceRepository>.internal(
      financeRepository,
      name: r'financeRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$financeRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FinanceRepositoryRef = AutoDisposeProviderRef<FinanceRepository>;
String _$fetchTransactionsUseCaseHash() =>
    r'ab91e11938b5b1b9b611ca67767aff83fff65468';

/// See also [fetchTransactionsUseCase].
@ProviderFor(fetchTransactionsUseCase)
final fetchTransactionsUseCaseProvider =
    AutoDisposeProvider<FetchTransactionsUseCase>.internal(
      fetchTransactionsUseCase,
      name: r'fetchTransactionsUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fetchTransactionsUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchTransactionsUseCaseRef =
    AutoDisposeProviderRef<FetchTransactionsUseCase>;
String _$addTransactionUseCaseHash() =>
    r'ee69874e8ce80ebb8e4e970301134b0046552252';

/// See also [addTransactionUseCase].
@ProviderFor(addTransactionUseCase)
final addTransactionUseCaseProvider =
    AutoDisposeProvider<AddTransactionUseCase>.internal(
      addTransactionUseCase,
      name: r'addTransactionUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addTransactionUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddTransactionUseCaseRef =
    AutoDisposeProviderRef<AddTransactionUseCase>;
String _$getBalanceUseCaseHash() => r'f13f8a6136c2473c43efec5c43de07c3693b40b2';

/// See also [getBalanceUseCase].
@ProviderFor(getBalanceUseCase)
final getBalanceUseCaseProvider =
    AutoDisposeProvider<GetBalanceUseCase>.internal(
      getBalanceUseCase,
      name: r'getBalanceUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getBalanceUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetBalanceUseCaseRef = AutoDisposeProviderRef<GetBalanceUseCase>;
String _$balanceHash() => r'f4d002d2b4dd541aa077730726a54357cfc03440';

/// See also [balance].
@ProviderFor(balance)
final balanceProvider = AutoDisposeFutureProvider<double>.internal(
  balance,
  name: r'balanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$balanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BalanceRef = AutoDisposeFutureProviderRef<double>;
String _$financeNotifierHash() => r'42762211a8da4366bb7a5302c59e2c2343dc33e2';

/// See also [FinanceNotifier].
@ProviderFor(FinanceNotifier)
final financeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      FinanceNotifier,
      List<Transaction>
    >.internal(
      FinanceNotifier.new,
      name: r'financeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$financeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FinanceNotifier = AutoDisposeAsyncNotifier<List<Transaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
