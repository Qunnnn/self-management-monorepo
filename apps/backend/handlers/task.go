package handlers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"self-management-monorepo/apps/backend/db"
	"self-management-monorepo/apps/backend/models"
)

// GetTasks returns all active tasks (not soft-deleted), with optional filtering
func GetTasks(w http.ResponseWriter, r *http.Request) {
	completedStr := r.URL.Query().Get("completed")
	limitStr := r.URL.Query().Get("limit")
	offsetStr := r.URL.Query().Get("offset")

	query := `
		SELECT id, user_id, title, description, is_completed, created_at, deleted_at
		FROM tasks
		WHERE deleted_at IS NULL
	`
	var args []interface{}

	if completedStr != "" {
		completed, err := strconv.ParseBool(completedStr)
		if err != nil {
			http.Error(w, "Invalid completed parameter", http.StatusBadRequest)
			return
		}
		args = append(args, completed)
		query += fmt.Sprintf(" AND is_completed = $%d", len(args))
	}

	query += " ORDER BY id"

	if limitStr != "" {
		limit, err := strconv.Atoi(limitStr)
		if err != nil || limit < 0 {
			http.Error(w, "Invalid limit parameter", http.StatusBadRequest)
			return
		}
		args = append(args, limit)
		query += fmt.Sprintf(" LIMIT $%d", len(args))
	}

	if offsetStr != "" {
		offset, err := strconv.Atoi(offsetStr)
		if err != nil || offset < 0 {
			http.Error(w, "Invalid offset parameter", http.StatusBadRequest)
			return
		}
		args = append(args, offset)
		query += fmt.Sprintf(" OFFSET $%d", len(args))
	}

	rows, err := db.DB.Query(query, args...)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var tasks []models.Task
	for rows.Next() {
		var t models.Task
		if err := rows.Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		tasks = append(tasks, t)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tasks)
}

// GetTask returns a single task by ID
func GetTask(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid task ID", http.StatusBadRequest)
		return
	}

	var t models.Task
	err = db.DB.QueryRow(`
		SELECT id, user_id, title, description, is_completed, created_at, deleted_at
		FROM tasks
		WHERE id = $1 AND deleted_at IS NULL
	`, id).Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt)

	if err == sql.ErrNoRows {
		http.Error(w, "Task not found", http.StatusNotFound)
		return
	}
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(t)
}

// GetTasksByUser returns all tasks for a specific user
func GetTasksByUser(w http.ResponseWriter, r *http.Request) {
	userIDStr := r.PathValue("id")
	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	completedStr := r.URL.Query().Get("completed")
	limitStr := r.URL.Query().Get("limit")
	offsetStr := r.URL.Query().Get("offset")

	query := `
		SELECT id, user_id, title, description, is_completed, created_at, deleted_at
		FROM tasks
		WHERE user_id = $1 AND deleted_at IS NULL
	`
	args := []interface{}{userID}

	if completedStr != "" {
		completed, err := strconv.ParseBool(completedStr)
		if err != nil {
			http.Error(w, "Invalid completed parameter", http.StatusBadRequest)
			return
		}
		args = append(args, completed)
		query += fmt.Sprintf(" AND is_completed = $%d", len(args))
	}

	query += " ORDER BY id"

	if limitStr != "" {
		limit, err := strconv.Atoi(limitStr)
		if err != nil || limit < 0 {
			http.Error(w, "Invalid limit parameter", http.StatusBadRequest)
			return
		}
		args = append(args, limit)
		query += fmt.Sprintf(" LIMIT $%d", len(args))
	}

	if offsetStr != "" {
		offset, err := strconv.Atoi(offsetStr)
		if err != nil || offset < 0 {
			http.Error(w, "Invalid offset parameter", http.StatusBadRequest)
			return
		}
		args = append(args, offset)
		query += fmt.Sprintf(" OFFSET $%d", len(args))
	}

	rows, err := db.DB.Query(query, args...)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var tasks []models.Task
	for rows.Next() {
		var t models.Task
		if err := rows.Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		tasks = append(tasks, t)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tasks)
}

// CreateTask creates a new task
func CreateTask(w http.ResponseWriter, r *http.Request) {
	var req models.CreateTaskRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.Title == "" || req.UserID == 0 {
		http.Error(w, "Title and user_id are required", http.StatusBadRequest)
		return
	}

	var t models.Task
	err := db.DB.QueryRow(`
		INSERT INTO tasks (user_id, title, description)
		VALUES ($1, $2, $3)
		RETURNING id, user_id, title, description, is_completed, created_at, deleted_at
	`, req.UserID, req.Title, req.Description).Scan(
		&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt,
	)

	if err != nil {
		if strings.Contains(err.Error(), "foreign key") {
			http.Error(w, "User not found", http.StatusBadRequest)
			return
		}
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(t)
}

// CompleteTask marks a task as completed
func CompleteTask(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid task ID", http.StatusBadRequest)
		return
	}

	var t models.Task
	err = db.DB.QueryRow(`
		UPDATE tasks SET is_completed = true
		WHERE id = $1 AND deleted_at IS NULL
		RETURNING id, user_id, title, description, is_completed, created_at, deleted_at
	`, id).Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt)

	if err == sql.ErrNoRows {
		http.Error(w, "Task not found", http.StatusNotFound)
		return
	}
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(t)
}

// DeleteTask soft-deletes a task
func DeleteTask(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid task ID", http.StatusBadRequest)
		return
	}

	result, err := db.DB.Exec(`
		UPDATE tasks SET deleted_at = NOW()
		WHERE id = $1 AND deleted_at IS NULL
	`, id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		http.Error(w, "Task not found", http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
