# Quick Setup Guide

This is a condensed setup guide to get you running quickly. For detailed explanations, see [README.md](README.md).

## Prerequisites Check

```bash
# Check Go installation
go version
# Expected: go version go1.25.7 or higher

# Check PostgreSQL installation
psql --version
# Expected: psql (PostgreSQL) 14.x or higher
```

## 5-Minute Setup

### 1. Install Dependencies
```bash
cd /Users/Shared/self-management-backend
go mod download
```

### 2. Start PostgreSQL
```bash
# macOS
brew services start postgresql

# Or check if already running
brew services list
```

### 3. Create Database
```bash
# Create database
createdb pg_learning

# Connect to database
psql pg_learning
```

### 4. Create Tables

Copy and paste this into your psql prompt:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);
```

Type `\q` to exit psql.

### 5. Update Configuration

Edit [main.go](main.go) line 19 if needed:
```go
User: "qun",  // <- Change to your macOS username
```

Find your username:
```bash
whoami
```

### 6. Run the Server

```bash
go run main.go
```

You should see:
```
Connected to PostgreSQL successfully!
Server starting on http://localhost:8080
```

### 7. Test It!

Open a new terminal and run:

```bash
# Test health check
curl http://localhost:8080/health

# Create a user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}'

# Get all users
curl http://localhost:8080/users
```

## Common Issues

### Issue: "connection refused"
**Solution**: PostgreSQL isn't running
```bash
brew services start postgresql
```

### Issue: "database does not exist"
**Solution**: Create the database
```bash
createdb pg_learning
```

### Issue: "relation 'users' does not exist"
**Solution**: Run the CREATE TABLE commands in Step 4

### Issue: "permission denied"
**Solution**: Update the User field in main.go to your username
```bash
whoami  # Use this username in main.go
```

### Issue: Port 8080 in use
**Solution**: Change port in main.go:42 or kill existing process
```bash
lsof -i :8080  # Find what's using port 8080
```

## Quick Reference

### Start Server
```bash
go run main.go
```

### Build Executable
```bash
go build -o pg-api
./pg-api
```

### View Database
```bash
psql pg_learning
```

### Useful psql Commands
```sql
\dt              -- List all tables
\d users         -- Describe users table
SELECT * FROM users;     -- View all users
SELECT * FROM tasks;     -- View all tasks
\q               -- Quit psql
```

### Stop Server
Press `Ctrl + C` in the terminal running the server

## Next Steps

Once everything is working, check out:
- [README.md](README.md) - Full documentation with API examples
- [main.go](main.go) - See how routing works
- [handlers/user.go](handlers/user.go) - See how endpoints are implemented
- [db/db.go](db/db.go) - Understand database connection

Happy learning!
