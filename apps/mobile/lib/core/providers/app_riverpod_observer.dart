import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';

class AppRiverpodObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    logger.d('Provider ${provider.name ?? provider.runtimeType} initialized: $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    logger.d('Provider ${provider.name ?? provider.runtimeType} disposed');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.d('Provider ${provider.name ?? provider.runtimeType} updated: $previousValue -> $newValue');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logger.e(
      'Provider ${provider.name ?? provider.runtimeType} failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
