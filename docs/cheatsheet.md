# Quick Reference Cheat Sheet

A quick reference for common commands and operations.

## 🚀 Server Commands

```bash
# Start server
go run main.go

# Build executable
go build -o pg-api

# Run executable
./pg-api

# Install dependencies
go mod download

# Update dependencies
go mod tidy

# Stop server
Ctrl + C
```

## 🗄️ Database Commands

### PostgreSQL Service
```bash
# Start PostgreSQL (macOS)
brew services start postgresql

# Stop PostgreSQL
brew services stop postgresql

# Restart PostgreSQL
brew services restart postgresql

# Check status
brew services list
```

### Database Management
```bash
# Create database
createdb pg_learning

# Drop database
dropdb pg_learning

# Connect to database
psql pg_learning

# List all databases
psql -l
```

### psql Commands (Inside psql)
```sql
\dt              -- List all tables
\d users         -- Describe users table
\l               -- List databases
\c pg_learning   -- Connect to database
\q               -- Quit psql
\?               -- Help
```

### Common SQL Queries
```sql
-- View all users
SELECT * FROM users;

-- View all tasks
SELECT * FROM tasks;

-- Count users
SELECT COUNT(*) FROM users;

-- Find user by email
SELECT * FROM users WHERE email = 'test@example.com';

-- View user's tasks
SELECT * FROM tasks WHERE user_id = 1;

-- View completed tasks
SELECT * FROM tasks WHERE is_completed = true;

-- Delete all tasks
DELETE FROM tasks;

-- Delete all users
DELETE FROM users;

-- Reset auto-increment
ALTER SEQUENCE users_id_seq RESTART WITH 1;
ALTER SEQUENCE tasks_id_seq RESTART WITH 1;
```

## 📡 API Testing Commands

### curl Commands

```bash
# Health check
curl http://localhost:8080/health

# Create user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com"}'

# Get all users
curl http://localhost:8080/users

# Get user by ID
curl http://localhost:8080/users/1

# Delete user
curl -X DELETE http://localhost:8080/users/1

# Create task
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"user_id":1,"title":"My Task"}'

# Get all tasks
curl http://localhost:8080/tasks

# Complete task
curl -X POST http://localhost:8080/tasks/1/complete

# Get user's tasks
curl http://localhost:8080/users/1/tasks
```

### HTTPie Commands (prettier alternative)

```bash
# Install
brew install httpie

# Create user
http POST localhost:8080/users name="John" email="john@example.com"

# Get users
http GET localhost:8080/users

# Create task
http POST localhost:8080/tasks user_id:=1 title="My Task"

# Complete task
http POST localhost:8080/tasks/1/complete
```

### jq (JSON processor)

```bash
# Install
brew install jq

# Pretty print
curl http://localhost:8080/users | jq

# Extract field
curl http://localhost:8080/users | jq '.[0].name'

# Count items
curl http://localhost:8080/users | jq 'length'

# Filter by field
curl http://localhost:8080/tasks | jq '.[] | select(.is_completed == true)'
```

## 🐛 Debugging Commands

```bash
# Check if port 8080 is in use
lsof -i :8080

# Kill process on port 8080
kill -9 $(lsof -t -i:8080)

# View Go version
go version

# View PostgreSQL version
psql --version

# Check PostgreSQL connection
psql -d pg_learning -c "SELECT 1"

# View environment variables
printenv | grep GO

# Test database connection
psql -d pg_learning -c "\dt"
```

## 📁 File Structure Quick Reference

```
main.go           → Server setup, routes
db/db.go          → Database connection
models/user.go    → User struct
models/task.go    → Task struct
handlers/user.go  → User endpoints
handlers/task.go  → Task endpoints
go.mod            → Dependencies
```

## 🔧 Common Issues & Fixes

```bash
# Issue: "database does not exist"
createdb pg_learning

# Issue: "relation does not exist"
# Run CREATE TABLE commands in psql

# Issue: "connection refused"
brew services start postgresql

# Issue: "port already in use"
kill -9 $(lsof -t -i:8080)

# Issue: "permission denied"
# Update username in main.go:19

# Issue: Go dependencies missing
go mod download
go mod tidy
```

## 📝 Go Code Snippets

### Read request body
```go
var req CreateUserRequest
json.NewDecoder(r.Body).Decode(&req)
```

### Write JSON response
```go
w.Header().Set("Content-Type", "application/json")
json.NewEncoder(w).Encode(user)
```

### Send error
```go
http.Error(w, "Error message", http.StatusBadRequest)
```

### Execute SQL query
```go
row := db.DB.QueryRow("SELECT * FROM users WHERE id = $1", id)
```

### Execute SQL with multiple rows
```go
rows, err := db.DB.Query("SELECT * FROM users")
defer rows.Close()
for rows.Next() {
    // scan row
}
```

### Parse URL parameter
```go
idStr := strings.TrimPrefix(r.URL.Path, "/users/")
id, _ := strconv.Atoi(idStr)
```

## 🎯 HTTP Status Codes

```
200 OK                  - Success
201 Created             - Resource created
204 No Content          - Success with no body
400 Bad Request         - Invalid input
404 Not Found           - Resource doesn't exist
405 Method Not Allowed  - Wrong HTTP method
500 Internal Server Error - Server error
```

## 📊 Database Table Schemas

### Users Table
```sql
id         SERIAL PRIMARY KEY
name       VARCHAR(100) NOT NULL
email      VARCHAR(100) UNIQUE NOT NULL
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Tasks Table
```sql
id           SERIAL PRIMARY KEY
user_id      INTEGER REFERENCES users(id)
title        VARCHAR(200) NOT NULL
description  TEXT
is_completed BOOLEAN DEFAULT FALSE
created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
deleted_at   TIMESTAMP
```

## 🔍 VS Code Tips

```bash
# Format code
Shift + Option + F

# Go to definition
Cmd + Click

# Find all references
Shift + F12

# Rename symbol
F2

# Show problems
Cmd + Shift + M
```

## 🧪 Testing Workflow

```bash
# 1. Start server
go run main.go

# 2. In new terminal, test health
curl http://localhost:8080/health

# 3. Create user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@example.com"}'

# 4. Verify in database
psql pg_learning -c "SELECT * FROM users;"

# 5. Test get users
curl http://localhost:8080/users | jq
```

## 💡 Pro Tips

```bash
# Auto-reload server on file changes (install air)
go install github.com/air-verse/air@latest
air

# Format all Go files
go fmt ./...

# Check for errors
go vet ./...

# View module dependencies
go list -m all

# Clean build cache
go clean -cache

# Create database backup
pg_dump pg_learning > backup.sql

# Restore database
psql pg_learning < backup.sql
```

## 🌐 Environment Variables

```bash
# Set environment variable (temporary)
export DB_HOST=localhost
export DB_PORT=5432

# View environment variable
echo $DB_HOST

# Create .env file
cat > .env << EOF
DB_HOST=localhost
DB_PORT=5432
DB_USER=qun
DB_NAME=pg_learning
EOF

# Load .env file (requires godotenv)
# See LEARNING_PATH.md Level 6
```

## 📱 API Response Examples

### Success Response
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2024-02-11T20:30:00Z"
}
```

### Error Response
```json
{
  "error": "User not found"
}
```

### Array Response
```json
[
  {"id": 1, "name": "User 1"},
  {"id": 2, "name": "User 2"}
]
```

## 🎨 JSON Request Templates

### Create User
```json
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

### Create Task
```json
{
  "user_id": 1,
  "title": "Task title",
  "description": "Optional description"
}
```

---

Keep this cheat sheet handy while developing! Bookmark the sections you use most often.
