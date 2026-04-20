# Flutter Migration Phase 1: Foundation & Auth Implementation Plan

> **For agentic workers:** Use the executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Initialize the Flutter application, implement the App design system (inspired by Notion), and port the Auth feature from iOS.

**Architecture:** Clean Architecture with Feature-first organization. Data layer uses Mock Data Sources, Domain layer contains business logic, and Presentation layer uses Riverpod 2.x for state management.

**Tech Stack:** Flutter, Riverpod (Code Gen), GoRouter, Freezed, Dio.

---

### Task 1: Project Initialization
**Files:**
- Create: `apps/mobile/`
- Modify: `pubspec.yaml`

- [ ] **Step 1: Create Flutter project**
Run: `flutter create --org com.qunnnn.selfmanagement --project-name mobile apps/mobile`
- [ ] **Step 2: Add dependencies**
Update `apps/mobile/pubspec.yaml` with:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^13.2.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  dio: ^5.4.1
  shared_preferences: ^2.2.2
  google_fonts: ^6.2.1

dev_dependencies:
  build_runner: ^2.4.8
  riverpod_generator: ^2.3.11
  freezed: ^2.4.7
  json_serializable: ^6.7.1
```
- [ ] **Step 3: Run pub get**
Run: `cd apps/mobile && flutter pub get`

### Task 2: Core Design System
**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_text_theme.dart`
- Create: `lib/core/theme/app_theme.dart`
- Create: `lib/core/widgets/app_button.dart`
- Create: `lib/core/widgets/app_text_field.dart`

- [ ] **Step 1: Implement Colors**
Create `lib/core/theme/app_colors.dart` with constants from `DESIGN.md`.
- [ ] **Step 2: Implement Typography**
Create `lib/core/theme/app_text_theme.dart` using Google Fonts (Inter) and custom letter-spacing.
- [ ] **Step 3: Create AppButton**
Implement `AppButton` supporting Primary (Blue), Secondary (Warm Gray), and Pill styles.
- [ ] **Step 4: Create AppTextField**
Implement `AppTextField` with the "Whisper Border" (1px solid rgba(0,0,0,0.1)).

### Task 3: Auth Domain Layer
**Files:**
- Create: `lib/features/auth/domain/entities/user.dart`
- Create: `lib/features/auth/domain/entities/auth_tokens.dart`
- Create: `lib/features/auth/domain/repositories/auth_repository.dart`
- Create: `lib/features/auth/domain/use_cases/login_use_case.dart`

- [ ] **Step 1: Create Entities**
Define `User` and `AuthTokens` using `freezed`.
- [ ] **Step 2: Create Repository Interface**
Define `abstract class AuthRepository`.
- [ ] **Step 3: Create LoginUseCase**
Implement field validation logic (empty email/password) before calling the repository.

### Task 4: Auth Data Layer (Mock)
**Files:**
- Create: `lib/features/auth/data/models/user_model.dart`
- Create: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- Create: `lib/features/auth/data/data_sources/auth_mock_data_source.dart`

- [ ] **Step 1: Implement Mock Data Source**
Create `AuthMockDataSource` that returns a hardcoded `UserModel` after a 1-second delay.
- [ ] **Step 2: Implement Repository**
Create `AuthRepositoryImpl` and handle local token storage via `SharedPreferences`.
- [ ] **Step 3: Run Code Gen**
Run: `dart run build_runner build --delete-conflicting-outputs`

### Task 5: Auth Presentation Layer
**Files:**
- Create: `lib/features/auth/presentation/providers/auth_provider.dart`
- Create: `lib/features/auth/presentation/pages/login_page.dart`

- [ ] **Step 1: Create Auth Notifier**
Implement `AuthNotifier` using `@riverpod` (AsyncNotifier) to manage login state.
- [ ] **Step 2: Build Login Page**
Use `AppTextField` and `AppButton` to build the login UI.
- [ ] **Step 3: Run Code Gen**
Run: `dart run build_runner build --delete-conflicting-outputs`

### Task 6: Routing & App Entry
**Files:**
- Create: `lib/app.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Setup GoRouter**
Configure routes for `/login` and `/home` (placeholder).
- [ ] **Step 2: Initialize App**
Update `main.dart` to use `ProviderScope` and `App` widget.
