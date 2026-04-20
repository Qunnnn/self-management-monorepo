# Functional Error Handling & Retrofit Migration Implementation Plan

> **For agentic workers:** Use the executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the mobile application's network layer to use `fpdart`'s `Either<Failure, T>` pattern and migrate data sources to `Retrofit`.

**Architecture:**
- **Core**: Define a sealed `Failure` hierarchy in `lib/core/error/failure.dart`.
- **Network**: Update `DioClient` to provide centralized error handling.
- **Data Layer**: Convert data sources to Retrofit-based clients returning `Either`.

**Tech Stack:**
- `fpdart` (Either, TaskEither)
- `dio`
- `retrofit`
- `riverpod` (for dependency injection)

---

### Task 1: Dependencies & Core Error Layer

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/core/error/failure.dart`
- Delete: `lib/core/network/api_error.dart`
- Modify: `lib/core/network/index.dart`

- [ ] **Step 1: Add dependencies**
Update `pubspec.yaml`:
```yaml
dependencies:
  fpdart: ^1.1.0
  retrofit: ^4.1.0
dev_dependencies:
  retrofit_generator: ^8.1.0
```
Run `flutter pub get`.

- [ ] **Step 2: Create Failure class**
Create `lib/core/error/failure.dart`:
```dart
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure() : super('No Internet Connection');
}

class DecodingFailure extends Failure {
  const DecodingFailure(Object error) : super('Failed to decode response: $error');
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}
```

- [ ] **Step 3: Update Network Exports**
Modify `lib/core/network/index.dart`:
Replace `export 'api_error.dart';` with `export '../error/failure.dart';`.

- [ ] **Step 4: Remove api_error.dart**
Delete `lib/core/network/api_error.dart`.

- [ ] **Step 5: Commit**
`git add . && git commit -m "feat: add fpdart/retrofit and define Failure hierarchy"`

---

### Task 2: Centralized Error Mapping & DioClient Update

**Files:**
- Modify: `lib/core/network/dio_client.dart`

- [ ] **Step 1: Add error mapping helper**
In `lib/core/network/dio_client.dart`, add:
```dart
Failure _mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const ConnectionFailure();
    case DioExceptionType.badResponse:
      return ServerFailure(
        e.response?.statusMessage ?? 'Server Error',
        statusCode: e.response?.statusCode,
      );
    case DioExceptionType.connectionError:
      return const ConnectionFailure();
    default:
      return UnknownFailure(e.message ?? 'An unknown error occurred');
  }
}
```

- [ ] **Step 2: Update DioClient methods (Optional wrapper)**
Add a generic request wrapper to `DioClient`:
```dart
Future<Either<Failure, T>> request<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } on DioException catch (e) {
    return Left(_mapDioException(e));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}
```

- [ ] **Step 3: Commit**
`git add . && git commit -m "feat: implement centralized error mapping in DioClient"`

---

### Task 3: Auth Data Source Migration

**Files:**
- Create: `lib/features/auth/data/data_sources/auth_api.dart`
- Modify: `lib/features/auth/data/data_sources/auth_remote_data_source.dart`

- [ ] **Step 1: Define AuthApi (Retrofit)**
Create `lib/features/auth/data/data_sources/auth_api.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> body);

  @GET('/auth/me')
  Future<UserModel> fetchCurrentUser();
}
```

- [ ] **Step 2: Run code generation**
`dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 3: Update AuthRemoteDataSource**
Modify `lib/features/auth/data/data_sources/auth_remote_data_source.dart`:
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';
import '../../../../core/error/failure.dart';
import 'auth_api.dart';
// ... imports

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio, this._api);
  final Dio _dio;
  final AuthApi _api;

  Future<Either<Failure, (UserModel, AuthTokensModel)>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.login({
        'email': email,
        'password': password,
      });
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final tokens = AuthTokensModel.fromJson(response['tokens'] as Map<String, dynamic>);
      return Right((user, tokens));
    } on DioException catch (e) {
      // Use a helper from DioClient or local mapping
      return Left(ServerFailure(e.message ?? 'Login failed'));
    }
  }
}
```

- [ ] **Step 4: Commit**

---

### Task 4: Skill Documentation Update

**Files:**
- Modify: `.agents/skills/flutter-handling-http-and-json/SKILL.md`

- [ ] **Step 1: Add "Functional Error Handling" section**
Update the skill to include `Either` and `TaskEither` patterns.

- [ ] **Step 2: Commit**
