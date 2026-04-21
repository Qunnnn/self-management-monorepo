# Enhanced Logging Integration Implementation Plan

> **For agentic workers:** Use the executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate `logger` and `pretty_dio_logger` to provide structured, readable logs for network activity and Riverpod state changes.

**Architecture:** Use a centralized `logger` utility for consistent formatting and replace basic interceptors with `PrettyDioLogger` for advanced network debugging.

**Tech Stack:** `logger: 2.7.0`, `pretty_dio_logger: 1.4.0`, `dio: 5.9.0`, `flutter_riverpod: 3.0.3`.

---

### Task 1: Dependencies and Environment

**Files:**
- Modify: `apps/mobile/pubspec.yaml`

- [ ] **Step 1: Update dependencies**

Add the packages with pinned versions:
```yaml
dependencies:
  # ... existing dependencies
  logger: 2.7.0
  pretty_dio_logger: 1.4.0
```

- [ ] **Step 2: Install dependencies**

Run: `flutter pub get` in `apps/mobile`
Expected: Successful installation without version conflicts.

- [ ] **Step 3: Commit**

```bash
git add apps/mobile/pubspec.yaml
git commit -m "chore: add logger and pretty_dio_logger dependencies"
```

### Task 2: Centralized Logger Utility

**Files:**
- Create: `apps/mobile/lib/core/utils/logger.dart`
- Modify: `apps/mobile/lib/core/utils/index.dart`

- [ ] **Step 1: Create logger utility**

Create `apps/mobile/lib/core/utils/logger.dart`:
```dart
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);
```

- [ ] **Step 2: Export logger utility**

Update `apps/mobile/lib/core/utils/index.dart` (if it exists):
```dart
export 'logger.dart';
```

- [ ] **Step 3: Commit**

```bash
git add apps/mobile/lib/core/utils/logger.dart apps/mobile/lib/core/utils/index.dart
git commit -m "feat: add centralized logger utility"
```

### Task 3: Network Logging Integration

**Files:**
- Modify: `apps/mobile/lib/core/network/dio_client.dart`

- [ ] **Step 1: Update imports and replace interceptors**

Modify `apps/mobile/lib/core/network/dio_client.dart`:
- Import `pretty_dio_logger`.
- Replace `LogInterceptor` with `PrettyDioLogger`.

```dart
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// ... other imports

class DioClient {
  DioClient(TokenStorage tokenStorage) {
    _publicDio = Dio(BaseOptions(
      baseUrl: NetworkConfig.baseURL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ));
    
    _publicDio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    _dio = Dio(BaseOptions(
      baseUrl: NetworkConfig.baseURL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ));

    _dio.interceptors.add(AuthInterceptor(tokenStorage));
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }
  // ... rest of the class
}
```

- [ ] **Step 2: Commit**

```bash
git add apps/mobile/lib/core/network/dio_client.dart
git commit -m "feat: replace LogInterceptor with PrettyDioLogger"
```

### Task 4: Provider Observer Integration

**Files:**
- Modify: `apps/mobile/lib/core/providers/app_riverpod_observer.dart`

- [ ] **Step 1: Refactor to use logger**

Modify `apps/mobile/lib/core/providers/app_riverpod_observer.dart`:
- Import the new `logger` utility.
- Replace `dart:developer.log` with `logger.d` or `logger.e`.

```dart
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
```

- [ ] **Step 2: Commit**

```bash
git add apps/mobile/lib/core/providers/app_riverpod_observer.dart
git commit -m "feat: update AppRiverpodObserver to use logger"
```

### Task 5: Verification

- [ ] **Step 1: Static analysis**

Run: `flutter analyze` in `apps/mobile`
Expected: No issues found.

- [ ] **Step 2: Commit final changes**

```bash
git add .
git commit -m "feat: complete logging integration"
```
