import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';

final class AppRiverPodObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    logger.d('Provider ${context.provider.name ?? context.provider.runtimeType} initialized: $value');
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    logger.d('Provider ${context.provider.name ?? context.provider.runtimeType} disposed');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    logger.d('Provider ${context.provider.name ?? context.provider.runtimeType} updated: $previousValue -> $newValue');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    logger.e(
      'Provider ${context.provider.name ?? context.provider.runtimeType} failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
