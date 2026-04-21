# Design Spec: Enhanced Logging Integration

## Overview
Add `logger` and `pretty_dio_logger` packages to the mobile application to improve debugging and observability of network requests and state changes.

## Goals
- Provide human-readable, formatted network logs.
- Provide structured logs for Riverpod provider state transitions.
- Centralize logging configuration to ensure consistency and ease of future modifications.
- Use strict versioning for project stability.

## Dependencies
Update `apps/mobile/pubspec.yaml`:
- `logger: 2.7.0`
- `pretty_dio_logger: 1.4.0`

## Architecture

### 1. Core Logger Utility
**File:** `lib/core/utils/logger.dart`
**Purpose:** Provide a singleton `Logger` instance with a customized `PrettyPrinter`.

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

### 2. Network Logging
**File:** `lib/core/network/dio_client.dart`
**Change:** Replace `LogInterceptor` with `PrettyDioLogger` in both `_publicDio` and `_dio` instances.

**Configuration:**
```dart
PrettyDioLogger(
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: true,
  maxWidth: 90,
)
```

### 3. Provider State Observation
**File:** `lib/core/providers/app_riverpod_observer.dart`
**Change:** Update `didAddProvider`, `didDisposeProvider`, `didUpdateProvider`, and `providerDidFail` to use the `logger` utility instead of `dart:developer.log`.

## Implementation Plan
1. Update `pubspec.yaml` with pinned versions.
2. Run `flutter pub get`.
3. Create `lib/core/utils/logger.dart`.
4. Refactor `DioClient` to use `PrettyDioLogger`.
5. Refactor `AppRiverpodObserver` to use `logger`.
6. Verify logs in the debug console.

## Testing
- Trigger an API request and verify the "pretty" network log output.
- Observe state changes in the console and verify formatted provider logs.
