// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskDataSourceHash() => r'be0805440783de17f9bc255bcdfde4215103d128';

/// See also [taskDataSource].
@ProviderFor(taskDataSource)
final taskDataSourceProvider = AutoDisposeProvider<TaskMockDataSource>.internal(
  taskDataSource,
  name: r'taskDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskDataSourceRef = AutoDisposeProviderRef<TaskMockDataSource>;
String _$taskRepositoryHash() => r'e4719bd1208d34cf67a4b3510be85636830d0c86';

/// See also [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = AutoDisposeProvider<TaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRepositoryRef = AutoDisposeProviderRef<TaskRepository>;
String _$fetchTasksUseCaseHash() => r'f06341f9617ff461283f0a2868633205bdfa006c';

/// See also [fetchTasksUseCase].
@ProviderFor(fetchTasksUseCase)
final fetchTasksUseCaseProvider =
    AutoDisposeProvider<FetchTasksUseCase>.internal(
      fetchTasksUseCase,
      name: r'fetchTasksUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fetchTasksUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchTasksUseCaseRef = AutoDisposeProviderRef<FetchTasksUseCase>;
String _$createTaskUseCaseHash() => r'30da0aa1ce95a757cc504b8de1932976d085c5bd';

/// See also [createTaskUseCase].
@ProviderFor(createTaskUseCase)
final createTaskUseCaseProvider =
    AutoDisposeProvider<CreateTaskUseCase>.internal(
      createTaskUseCase,
      name: r'createTaskUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createTaskUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateTaskUseCaseRef = AutoDisposeProviderRef<CreateTaskUseCase>;
String _$updateTasksUseCaseHash() =>
    r'948d7ee60baf4e4d7036134140866fdd123503bc';

/// See also [updateTasksUseCase].
@ProviderFor(updateTasksUseCase)
final updateTasksUseCaseProvider =
    AutoDisposeProvider<UpdateTaskUseCase>.internal(
      updateTasksUseCase,
      name: r'updateTasksUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$updateTasksUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateTasksUseCaseRef = AutoDisposeProviderRef<UpdateTaskUseCase>;
String _$deleteTaskUseCaseHash() => r'4b3751dcee983d369eeee3f47008e34cc87cb09b';

/// See also [deleteTaskUseCase].
@ProviderFor(deleteTaskUseCase)
final deleteTaskUseCaseProvider =
    AutoDisposeProvider<DeleteTaskUseCase>.internal(
      deleteTaskUseCase,
      name: r'deleteTaskUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteTaskUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteTaskUseCaseRef = AutoDisposeProviderRef<DeleteTaskUseCase>;
String _$tasksNotifierHash() => r'a53099e5cbe775cc3de200e6716e2a2acb70c483';

/// See also [TasksNotifier].
@ProviderFor(TasksNotifier)
final tasksNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TasksNotifier, List<TodoTask>>.internal(
      TasksNotifier.new,
      name: r'tasksNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tasksNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TasksNotifier = AutoDisposeAsyncNotifier<List<TodoTask>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
