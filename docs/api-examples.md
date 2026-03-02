# API Examples & Testing

A collection of ready-to-use API examples for testing your backend.

## Table of Contents
- [Health Check](#health-check)
- [User Operations](#user-operations)
- [Task Operations](#task-operations)
- [Complete Workflow Examples](#complete-workflow-examples)
- [Using Postman](#using-postman)
- [Using HTTPie](#using-httpie)

## Health Check

### Check Server Status
```bash
curl http://localhost:8080/health
```

Expected response: `OK`

---

## User Operations

### 1. Create User

**Request:**
```bash
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice Johnson",
    "email": "alice@example.com"
  }'
```

**Expected Response:**
```json
{
  "id": 1,
  "name": "Alice Johnson",
  "email": "alice@example.com",
  "created_at": "2024-02-11T20:30:00Z"
}
```

### 2. Get All Users

**Request:**
```bash
curl http://localhost:8080/users
```

**Expected Response:**
```json
[
  {
    "id": 1,
    "name": "Alice Johnson",
    "email": "alice@example.com",
    "created_at": "2024-02-11T20:30:00Z"
  }
]
```

### 3. Get Single User by ID

**Request:**
```bash
curl http://localhost:8080/users/1
```

**Expected Response:**
```json
{
  "id": 1,
  "name": "Alice Johnson",
  "email": "alice@example.com",
  "created_at": "2024-02-11T20:30:00Z"
}
```

### 4. Delete User

**Request:**
```bash
curl -X DELETE http://localhost:8080/users/1
```

**Expected Response:**
```json
{
  "message": "User deleted successfully"
}
```

### 5. Get User's Tasks

**Request:**
```bash
curl http://localhost:8080/users/1/tasks
```

**Expected Response:**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "title": "Complete Go tutorial",
    "description": "Finish learning backend basics",
    "is_completed": false,
    "created_at": "2024-02-11T20:35:00Z"
  }
]
```

---

## Task Operations

### 1. Create Task

**Request:**
```bash
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Learn PostgreSQL",
    "description": "Study database fundamentals"
  }'
```

**Expected Response:**
```json
{
  "id": 1,
  "user_id": 1,
  "title": "Learn PostgreSQL",
  "description": "Study database fundamentals",
  "is_completed": false,
  "created_at": "2024-02-11T20:35:00Z"
}
```

### 2. Create Task Without Description (Optional Field)

**Request:**
```bash
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Quick task"
  }'
```

### 3. Get All Tasks

**Request:**
```bash
curl http://localhost:8080/tasks
```

**Expected Response:**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "title": "Learn PostgreSQL",
    "description": "Study database fundamentals",
    "is_completed": false,
    "created_at": "2024-02-11T20:35:00Z"
  }
]
```

### 4. Get Single Task by ID

**Request:**
```bash
curl http://localhost:8080/tasks/1
```

### 5. Complete a Task

**Request (POST):**
```bash
curl -X POST http://localhost:8080/tasks/1/complete
```

**Request (PATCH - Alternative):**
```bash
curl -X PATCH http://localhost:8080/tasks/1/complete
```

**Expected Response:**
```json
{
  "id": 1,
  "user_id": 1,
  "title": "Learn PostgreSQL",
  "description": "Study database fundamentals",
  "is_completed": true,
  "created_at": "2024-02-11T20:35:00Z"
}
```

### 6. Delete Task

**Request:**
```bash
curl -X DELETE http://localhost:8080/tasks/1
```

**Expected Response:**
```json
{
  "message": "Task deleted successfully"
}
```

---

## Complete Workflow Examples

### Example 1: Create User and Task

```bash
# Step 1: Create a user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Bob Wilson","email":"bob@example.com"}'

# Step 2: Note the user ID from response (e.g., 2)

# Step 3: Create a task for that user
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"user_id":2,"title":"Build REST API","description":"Learn Go backend development"}'

# Step 4: View user's tasks
curl http://localhost:8080/users/2/tasks

# Step 5: Complete the task
curl -X POST http://localhost:8080/tasks/1/complete

# Step 6: Verify completion
curl http://localhost:8080/tasks/1
```

### Example 2: Multiple Users with Tasks

```bash
# Create first user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Developer One","email":"dev1@example.com"}'

# Create second user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Developer Two","email":"dev2@example.com"}'

# Create tasks for first user (assuming ID=1)
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"user_id":1,"title":"Task 1 for Dev1"}'

curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"user_id":1,"title":"Task 2 for Dev1"}'

# Create task for second user (assuming ID=2)
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"user_id":2,"title":"Task 1 for Dev2"}'

# View all users
curl http://localhost:8080/users

# View all tasks
curl http://localhost:8080/tasks

# View tasks for specific user
curl http://localhost:8080/users/1/tasks
```

### Example 3: Error Scenarios

```bash
# Try to get non-existent user
curl http://localhost:8080/users/999

# Try to create user with duplicate email
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"duplicate@example.com"}'

curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test2","email":"duplicate@example.com"}'

# Try to create task for non-existent user
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"user_id":999,"title":"Invalid task"}'

# Try unsupported HTTP method
curl -X PUT http://localhost:8080/users
```

---

## Using Postman

If you prefer a GUI, you can use Postman:

### Setup Collection

1. Create new collection: "Backend Learning API"
2. Set base URL variable: `{{base_url}}` = `http://localhost:8080`

### Example Requests

**Create User:**
- Method: POST
- URL: `{{base_url}}/users`
- Headers: `Content-Type: application/json`
- Body (raw JSON):
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com"
  }
  ```

**Get All Users:**
- Method: GET
- URL: `{{base_url}}/users`

**Create Task:**
- Method: POST
- URL: `{{base_url}}/tasks`
- Headers: `Content-Type: application/json`
- Body (raw JSON):
  ```json
  {
    "user_id": 1,
    "title": "My Task",
    "description": "Task description"
  }
  ```

---

## Using HTTPie

HTTPie is a user-friendly alternative to curl.

### Installation
```bash
brew install httpie
```

### Examples

**Create User:**
```bash
http POST localhost:8080/users name="Jane Doe" email="jane@example.com"
```

**Get All Users:**
```bash
http GET localhost:8080/users
```

**Create Task:**
```bash
http POST localhost:8080/tasks user_id:=1 title="Learn HTTPie" description="It's easier than curl"
```

**Complete Task:**
```bash
http POST localhost:8080/tasks/1/complete
```

**Delete User:**
```bash
http DELETE localhost:8080/users/1
```

---

## Testing Tips

### Pretty Print JSON with jq

```bash
# Install jq
brew install jq

# Use with curl
curl http://localhost:8080/users | jq

# Filter specific fields
curl http://localhost:8080/users | jq '.[].name'

# Get user count
curl http://localhost:8080/users | jq 'length'
```

### Save Response to Variable (bash)

```bash
# Create user and save response
response=$(curl -s -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@example.com"}')

# Extract user ID
user_id=$(echo $response | jq -r '.id')

# Use in next request
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d "{\"user_id\":$user_id,\"title\":\"Auto-created task\"}"
```

### Quick Test Script

Create a file `test.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:8080"

echo "Testing health..."
curl $BASE_URL/health
echo -e "\n"

echo "Creating user..."
USER_RESPONSE=$(curl -s -X POST $BASE_URL/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}')
echo $USER_RESPONSE | jq
USER_ID=$(echo $USER_RESPONSE | jq -r '.id')
echo -e "\n"

echo "Creating task for user $USER_ID..."
TASK_RESPONSE=$(curl -s -X POST $BASE_URL/tasks \
  -H "Content-Type: application/json" \
  -d "{\"user_id\":$USER_ID,\"title\":\"Test Task\"}")
echo $TASK_RESPONSE | jq
TASK_ID=$(echo $TASK_RESPONSE | jq -r '.id')
echo -e "\n"

echo "Getting user's tasks..."
curl -s $BASE_URL/users/$USER_ID/tasks | jq
echo -e "\n"

echo "Completing task..."
curl -s -X POST $BASE_URL/tasks/$TASK_ID/complete | jq
echo -e "\n"

echo "Test complete!"
```

Run it:
```bash
chmod +x test.sh
./test.sh
```

---

## Useful Database Queries

While testing, you might want to check the database directly:

```bash
# Connect to database
psql pg_learning
```

```sql
-- View all users
SELECT * FROM users;

-- View all tasks
SELECT * FROM tasks;

-- View tasks with user names
SELECT t.id, u.name as user_name, t.title, t.is_completed
FROM tasks t
JOIN users u ON t.user_id = u.id;

-- Count tasks by user
SELECT u.name, COUNT(t.id) as task_count
FROM users u
LEFT JOIN tasks t ON u.id = t.user_id
GROUP BY u.id, u.name;

-- View only completed tasks
SELECT * FROM tasks WHERE is_completed = true;

-- Delete all data (reset for testing)
DELETE FROM tasks;
DELETE FROM users;
```

Happy testing!
