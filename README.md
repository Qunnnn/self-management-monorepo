# Self-Management Mono-Repo

A mono-repo containing the Self-Management iOS app and its Go REST API backend.

## Structure

```
self-management-monorepo/
├── apps/
│   ├── ios/          # SwiftUI iOS app (Notes, Clean Architecture + MVVM)
│   └── backend/      # Go REST API (Users + Tasks, PostgreSQL)
└── docs/             # Consolidated documentation
```

## Apps

### iOS App (`apps/ios/`)

A SwiftUI application implementing a Notes feature using Clean Architecture and MVVM.

```bash
open apps/ios/self-management.xcodeproj
```

### Backend API (`apps/backend/`)

A Go REST API for managing users and tasks, backed by PostgreSQL.

```bash
cd apps/backend && go build -o pg-api . && ./pg-api
```

See [docs/setup.md](docs/setup.md) for database setup and [docs/api-examples.md](docs/api-examples.md) for API usage.

## Documentation

- [Setup Guide](docs/setup.md) - Database and environment setup
- [API Examples](docs/api-examples.md) - REST API usage with curl examples
- [Learning Path](docs/learning-path.md) - Backend development learning guide
- [Cheatsheet](docs/cheatsheet.md) - Quick reference for Go and PostgreSQL

## Developer Tools & Rules

This project includes integrated rules and assistant skills to streamline development:

- **Integrated Rules & Skills**: Coding standards and expert capabilities are defined in `.agents/skills/` (backend-go, ios-swift, monorepo, brainstorming).
