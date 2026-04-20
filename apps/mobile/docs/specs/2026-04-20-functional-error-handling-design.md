# Design Spec: Functional API Error Handling with Either

- **Date**: 2026-04-20
- **Status**: Approved
- **Topic**: Refactoring network and error handling to use `Either<Failure, T>` with `fpdart`.

## 1. Objective
Replace the exception-based error handling in the mobile application with a functional approach using `Either` from the `fpdart` package. This improves type safety and forces explicit error handling at the call site.

## 2. Architecture Changes

### 2.1. Core Error Layer
- Create `lib/core/error/failure.dart`.
- Define a sealed class `Failure` with a `message` property.
- Implement specific failures:
    - `ServerFailure` (HTTP errors, API business logic errors)
    - `ConnectionFailure` (Network unreachable)
    - `DecodingFailure` (JSON parsing errors)
    - `CacheFailure` (Local storage issues)

### 2.2. Network Layer Refactor
- Add `fpdart: ^1.1.0` to `pubspec.yaml`.
- Remove `lib/core/network/api_error.dart`.
- Update `DioClient` in `lib/core/network/dio_client.dart`:
    - Refactor `get`, `post`, `put`, `delete` methods.
    - Change return types to `Future<Either<Failure, T>>`.
    - Use a private helper to wrap Dio calls and catch `DioException`.

### 2.3. Data Layer Migration
- Update all Data Sources and Repositories to use `Either`.
- Example signature change:
    ```dart
    // Before
    Future<User> login(String email, String password);
    
    // After
    Future<Either<Failure, User>> login(String email, String password);
    ```

## 3. Implementation Details

### 3.1. Error Mapping
A central utility or method within `DioClient` will map `DioException` to `Failure`:
- `DioExceptionType.connectionTimeout`, `receiveTimeout` -> `ConnectionFailure`
- `DioExceptionType.badResponse` -> `ServerFailure` with status code and message.
- Default -> `ServerFailure`.

### 3.2. fpdart Usage
We will leverage `TaskEither` internally in `DioClient` for composition:
```dart
Future<Either<Failure, T>> request<T>(...) {
  return TaskEither<Failure, T>.tryCatch(
    () => _performCall(),
    (error, stackTrace) => _mapToFailure(error),
  ).run();
}
```

## 4. Migration Plan
1. Add dependencies.
2. Create `Failure` classes.
3. Refactor `DioClient`.
4. Refactor `AuthDataSource` (as the first module).
5. Refactor remaining modules.
6. Remove deprecated `APIError`.
