# Self-Management Flutter Migration - Phase 1: Foundation & Auth Design

## 1. Overview
This is Phase 1 of migrating the iOS Self-Management app to Flutter. This phase establishes the core Flutter project structure, implements the Notion-inspired design system (`DESIGN.md`), and ports the `Auth` feature (Login) using Clean Architecture and Riverpod.

## 2. Architecture & Tech Stack
- **Framework**: Flutter (project to be created at `apps/mobile/`)
- **State Management**: Riverpod 2.x (with `riverpod_annotation`)
- **Architecture**: Clean Architecture (Data, Domain, Presentation layers per feature)
- **Routing**: `go_router`
- **Code Generation**: `build_runner`, `freezed`, `json_serializable`
- **Network/Local**: `dio` + `retrofit`, `shared_preferences` (for token storage)

## 3. Project Structure
The new Flutter app will follow the strict modular structure outlined in `flutter-project-structure`:

```text
lib/
├── main.dart
├── app.dart                  # MaterialApp and GoRouter setup
├── core/
│   ├── theme/                # Notion design system (colors, typography from DESIGN.md)
│   ├── widgets/              # Reusable Notion UI components (Buttons, Inputs)
│   ├── network/              # Dio client setup
│   └── utils/                # Constants and extensions
└── features/
    └── auth/                 # Auth Feature Module
        ├── data/             # AuthDataSource, AuthRepositoryImpl, Models
        ├── domain/           # AuthRepository, LoginUseCase, User & AuthTokens entities
        └── presentation/     # LoginPage, AuthProvider (Riverpod AsyncNotifier)
```

## 4. App Design System Implementation
Based on `DESIGN.md`, the `core/theme` and `core/widgets` will implement:
- **Colors**: App Blue (`#0075de`), Warm White (`#f6f5f4`), Near-Black (`rgba(0,0,0,0.95)`).
- **Typography**: Inter font with specific weights (400, 500, 600, 700) and letter-spacing adjustments to mimic Notion's style.
- **Components**:
  - `AppButton` (Primary Blue, Secondary Warm Gray, Pill).
  - `AppTextField` with whisper borders (`1px solid rgba(0,0,0,0.1)`).

## 5. Auth Feature Porting
We will translate the iOS Auth implementation into Dart:

### Domain
- **Entities**: `User`, `AuthTokens`.
- **Use Cases**: `LoginUseCase` (validates empty fields and calls repository).
- **Errors**: Port `AuthError` (emptyEmail, emptyPassword, invalidCredentials).

### Data
- **Models**: `UserModel`, `AuthTokensModel` (via `freezed`).
- **DataSource**: `AuthRemoteDataSource` (mocked initially unless an API exists).
- **Repository**: `AuthRepositoryImpl` that saves tokens to local storage (replacing iOS SessionService role).

### Presentation
- **State**: `LoginNotifier` (`@riverpod`) managing `email`, `password`, `isLoading`, and `errorMessage`.
- **UI**: `LoginPage` built with `ConsumerWidget`, featuring the Notion-styled form.

## 6. Verification
- Validate the UI against the 9 rules in `DESIGN.md`.
- Run `flutter analyze` to ensure code quality.
- Verify state updates correctly via Riverpod without business logic inside widgets.
- Ensure all custom widgets (`AppButton`, `AppTextField`) follow the `AppTheme`.

## Open Questions (For User)
1. Should the Flutter app be created in the `apps/mobile/` directory or `apps/flutter/`?
2. Do we have a live backend API for Auth right now, or should I mock the authentication data source for Phase 1?
