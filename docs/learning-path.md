# 🚀 Backend Development Learning Path: Go & PostgreSQL

A structured roadmap to help you progress from beginner to professional backend developer.

## 📍 Where You Are Now
You have a working REST API with:
- ✅ Go server running on port 8080
- ✅ PostgreSQL database connection
- ✅ User and Task management
- ✅ CRUD operations

---

## 🎯 Learning Milestones

### Level 1: Understanding the Basics (You Are Here!)
**Goals:** Master the request/response cycle and Go's standard library.

- [x] **Code Walkthrough:** Identify where `json.NewDecoder` and `json.NewEncoder` are used in your handlers.
- [x] **Struct Tags:** Understand how `` `json:"name"` `` maps Go data to API responses.
- [x] **Exercise:** Add a `phone_number` field to the User struct and update your SQL schema.
- [x] **Exercise:** Ensure the `Password` field in your User struct has the `` `json:"-"` `` tag so it is never leaked in JSON.

### Level 2: Features & Query Parameters
**Goals:** Handle dynamic data and advanced SQL.

- [x] **Update Logic:** Implement `PUT /users/{id}` to modify existing records.
- [x] **Filtering:** Use `r.URL.Query()` to filter tasks (e.g., `/tasks?completed=true`).
- [x] **Pagination:** Implement `limit` and `offset` in your SQL queries to handle large datasets.
- [x] **Exercise:** Create a `GET /users/stats` endpoint returning a summary of total users and active tasks.

### Level 3: Robustness & Context
**Goals:** Handle errors like a pro and manage request lifecycles.

- [x] **Structured Logging:** Replace `log.Printf` with the standard library's `slog` package for JSON logs.
- [x] **Context Handling:** Pass `r.Context()` to all `db.QueryContext` calls to handle timeouts/cancellations.
- [x] **Validation:** Create a helper package to validate email formats and required fields.
- [x] **Exercise:** Create a global Error Handler that returns consistent JSON error objects.

### Level 4: Architecture & Dependency Injection
**Goals:** Write maintainable, decoupled code.

- [x] **Repository Pattern:** Move all SQL logic out of handlers and into a `Repository` layer.
- [x] **Dependency Injection:** Pass the Repository into your Handler structs instead of using global variables.
- [x] **Middleware:** Build a custom middleware that logs the execution time and status code of every request.



### Level 5: Testing & Mocking
**Goals:** Prove your code works without a database.

- [x] **Unit Testing:** Use the `testing` package to verify your validation logic.
- [x] **Mocking:** Create a "Mock" Repository to test handlers in isolation.
- [x] **Integration Tests:** Set up a separate test database to verify actual SQL query results.

### Level 6: Security & Auth
**Goals:** Protect user data and identify sessions.

- [x] **Password Hashing:** Implement `bcrypt` for secure password storage.
- [x] **JWT Auth:** Implement JSON Web Tokens to protect private API routes.
- [x] **Environment Secrets:** Use a `.env` file for DB credentials (never commit this to Git!).

### Level 7: Production Ready
**Goals:** Deploy and monitor.

- [x] **Docker:** Create a `Dockerfile` and `docker-compose.yml` for your API and DB.
- [x] **Migrations:** Use `golang-migrate` to version-control your database schema.
- [x] **Deployment:** Deploy the containerized app to Railway, Fly.io, or Render.

---

## 🛠️ Daily Practice Routine
- **30 min:** Read Go standard library source code (CMD+Click on functions).
- **60 min:** Build one specific feature or test.
- **15 min:** Refactor yesterday's code for better readability.

## 🤝 Helpful Resources
- [Go by Example](https://gobyexample.com/)
- [Effective Go](https://go.dev/doc/effective_go)
- [The Gophers Slack Community](https://gophers.slack.com/)

---
*Keep building, keep breaking things, and keep learning!*