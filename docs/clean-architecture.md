# Clean Architecture in Go

This document explains the Clean Architecture (also known as Onion Architecture or Hexagonal Architecture) pattern as applied to our Go backend.

![Clean Architecture Diagram](../assets/clean-arch.png)
*(Note: If you have an image, place it in the assets folder and link it here)*

## The Core Principle: Dependency Rule
The overriding rule of Clean Architecture is that **dependencies must point inwards**.
* The inner layers (Entities, Services) contain the business rules and must **never** depend on the outer layers.
* The outer layers (Delivery, Repository) contain framework-specific code (like HTTP routing or SQL queries) and depend on the inner layers.

## The Four Layers

### 1. Entities (`internal/entity/`)
* **What it is:** The core domain objects or data structures of your application.
* **Responsibilities:** Defines the shape of your data (e.g., a `User` struct or a `Task` struct). They contain the most general, high-level business rules.
* **Dependencies:** None. This layer imports zero external packages or other internal layers.

### 2. Services (`internal/service/`)
* **What it is:** The application-specific business logic.
* **Responsibilities:** Orchestrates the flow of data to and from the entities. It enforces business rules (e.g., "A user cannot be deleted if they have active tasks", or "Emails must be unique").
* **Dependencies:** Depends *only* on the `entity` layer.
* **The Secret Sauce:** It defines **interfaces** for what it needs from the outside world (e.g., `UserRepository`). It doesn't care *how* a user is saved (PostgreSQL, MongoDB), it just says "I need something that implements `SaveUser(user entity.User)`".

### 3. Interface Adapters / Delivery (`internal/delivery/http/`)
* **What it is:** The bridge between the Web/UI/CLI and your Services.
* **Responsibilities:** 
  * Parses incoming HTTP requests (JSON to Go structs).
  * Calls the appropriate Service function.
  * Formats the Service output back into HTTP responses (Go structs to JSON, HTTP Status Codes).
* **Dependencies:** Depends on `service` and `entity`.
* **Note:** Also often called "Controllers" or "Handlers".

### 4. Infrastructure / Repository (`internal/repository/postgres/`)
* **What it is:** The outermost layer containing databases, frameworks, and third-party tools.
* **Responsibilities:** Implements the interfaces defined by the Service layer. This is where actual SQL queries (`INSERT INTO...`) or API calls to external services live.
* **Dependencies:** Depends on `entity` and implements interfaces from `service`.

## Why Build Software This Way?

### 1. Framework Independence
The architecture does not depend on the existence of some library of feature-laden software. For example, if we want to switch our web framework from `net/http` to `Gin` or `Echo`, we only rewrite the `delivery/http` folder. The business logic stays exactly the same.

### 2. Database Independence
We can swap out PostgreSQL for MongoDB, CouchDB, or something else. Our business rules are not bound to a specific database. We just write a new `repository/mongo` implementation.

### 3. Testability
The business rules (Services) can be tested entirely without the UI, Database, Web Server, or any other external element. We simply pass a "Mock Repository" into the Service during testing.

## Example Flow: Creating a User

1. **HTTP Request** arrives at `delivery/http/user.go` (Handler).
2. **Handler** parses JSON into an `entity.CreateUserRequest`.
3. **Handler** calls `service.CreateUser(ctx, request)`.
4. **Service** validates the business rules (e.g., checking if the email format is correct).
5. **Service** calls the interface method `repository.Create(ctx, ...)`.
6. **Repository** (`repository/postgres/user.go`) executes the actual SQL `INSERT` statement and returns an `entity.User`.
7. **Service** returns the `entity.User` back to the Handler.
8. **Handler** serializes the `entity.User` to JSON and sends a `201 Created` HTTP response.
