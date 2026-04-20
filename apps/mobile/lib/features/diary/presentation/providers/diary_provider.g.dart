// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$diaryDataSourceHash() => r'81526b9fa19bb8e0bf0b34173843cf9943d17e4c';

/// See also [diaryDataSource].
@ProviderFor(diaryDataSource)
final diaryDataSourceProvider =
    AutoDisposeProvider<DiaryMockDataSource>.internal(
      diaryDataSource,
      name: r'diaryDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$diaryDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiaryDataSourceRef = AutoDisposeProviderRef<DiaryMockDataSource>;
String _$diaryRepositoryHash() => r'0f326c8a1b9ca4f9ebb8f19d8a4e1cb9486f7b54';

/// See also [diaryRepository].
@ProviderFor(diaryRepository)
final diaryRepositoryProvider = AutoDisposeProvider<DiaryRepository>.internal(
  diaryRepository,
  name: r'diaryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$diaryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiaryRepositoryRef = AutoDisposeProviderRef<DiaryRepository>;
String _$fetchDiaryEntriesUseCaseHash() =>
    r'4e2cbb98c9fc205056d595baabdf0baa99871e15';

/// See also [fetchDiaryEntriesUseCase].
@ProviderFor(fetchDiaryEntriesUseCase)
final fetchDiaryEntriesUseCaseProvider =
    AutoDisposeProvider<FetchDiaryEntriesUseCase>.internal(
      fetchDiaryEntriesUseCase,
      name: r'fetchDiaryEntriesUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fetchDiaryEntriesUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchDiaryEntriesUseCaseRef =
    AutoDisposeProviderRef<FetchDiaryEntriesUseCase>;
String _$createDiaryEntryUseCaseHash() =>
    r'5e935c6ed017aa847530efb9edd197af1c62fe3c';

/// See also [createDiaryEntryUseCase].
@ProviderFor(createDiaryEntryUseCase)
final createDiaryEntryUseCaseProvider =
    AutoDisposeProvider<CreateDiaryEntryUseCase>.internal(
      createDiaryEntryUseCase,
      name: r'createDiaryEntryUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createDiaryEntryUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateDiaryEntryUseCaseRef =
    AutoDisposeProviderRef<CreateDiaryEntryUseCase>;
String _$updateDiaryEntryUseCaseHash() =>
    r'35841905dc60516a796b2515d14b18aeafae761a';

/// See also [updateDiaryEntryUseCase].
@ProviderFor(updateDiaryEntryUseCase)
final updateDiaryEntryUseCaseProvider =
    AutoDisposeProvider<UpdateDiaryEntryUseCase>.internal(
      updateDiaryEntryUseCase,
      name: r'updateDiaryEntryUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$updateDiaryEntryUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateDiaryEntryUseCaseRef =
    AutoDisposeProviderRef<UpdateDiaryEntryUseCase>;
String _$deleteDiaryEntryUseCaseHash() =>
    r'1499d8ce0747c26e06f18a800830e12b092390b6';

/// See also [deleteDiaryEntryUseCase].
@ProviderFor(deleteDiaryEntryUseCase)
final deleteDiaryEntryUseCaseProvider =
    AutoDisposeProvider<DeleteDiaryEntryUseCase>.internal(
      deleteDiaryEntryUseCase,
      name: r'deleteDiaryEntryUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteDiaryEntryUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteDiaryEntryUseCaseRef =
    AutoDisposeProviderRef<DeleteDiaryEntryUseCase>;
String _$togglePinUseCaseHash() => r'eae355f7eea5c4d9386d9fc3edd6eb432068fbe0';

/// See also [togglePinUseCase].
@ProviderFor(togglePinUseCase)
final togglePinUseCaseProvider = AutoDisposeProvider<TogglePinUseCase>.internal(
  togglePinUseCase,
  name: r'togglePinUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$togglePinUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TogglePinUseCaseRef = AutoDisposeProviderRef<TogglePinUseCase>;
String _$diaryNotifierHash() => r'3549910a845a3d2b089f00ab1bfe9c1373d3813a';

/// See also [DiaryNotifier].
@ProviderFor(DiaryNotifier)
final diaryNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DiaryNotifier, List<DiaryEntry>>.internal(
      DiaryNotifier.new,
      name: r'diaryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$diaryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DiaryNotifier = AutoDisposeAsyncNotifier<List<DiaryEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
