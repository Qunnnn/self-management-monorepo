package handlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"net/http"
	"strconv"
	"strings"

	"self-management-monorepo/apps/backend/models"
	"self-management-monorepo/apps/backend/service"
	"self-management-monorepo/apps/backend/utils"
)

// TaskHandler handles task-related HTTP requests
type TaskHandler struct {
	svc service.TaskService
}

// NewTaskHandler creates a new TaskHandler with the given service
func NewTaskHandler(svc service.TaskService) *TaskHandler {
	return &TaskHandler{svc: svc}
}

// GetTasks returns all active tasks (not soft-deleted), with optional filtering
func (h *TaskHandler) GetTasks(w http.ResponseWriter, r *http.Request) {
	completedStr := r.URL.Query().Get("completed")
	limitStr := r.URL.Query().Get("limit")
	offsetStr := r.URL.Query().Get("offset")

	var completed *bool
	if completedStr != "" {
		c, err := strconv.ParseBool(completedStr)
		if err != nil {
			utils.WriteError(w, "Invalid completed parameter", http.StatusBadRequest, err)
			return
		}
		completed = &c
	}

	var limit *int
	if limitStr != "" {
		l, err := strconv.Atoi(limitStr)
		if err != nil || l < 0 {
			utils.WriteError(w, "Invalid limit parameter", http.StatusBadRequest, err)
			return
		}
		limit = &l
	}

	var offset *int
	if offsetStr != "" {
		o, err := strconv.Atoi(offsetStr)
		if err != nil || o < 0 {
			utils.WriteError(w, "Invalid offset parameter", http.StatusBadRequest, err)
			return
		}
		offset = &o
	}

	tasks, err := h.svc.GetTasks(r.Context(), completed, limit, offset)
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tasks)
}

// GetTask returns a single task by ID
func (h *TaskHandler) GetTask(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, "Invalid task ID", http.StatusBadRequest, err)
		return
	}

	t, err := h.svc.GetTaskByID(r.Context(), id)
	if errors.Is(err, sql.ErrNoRows) {
		utils.WriteError(w, "Task not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(t)
}

// GetTasksByUser returns all tasks for a specific user
func (h *TaskHandler) GetTasksByUser(w http.ResponseWriter, r *http.Request) {
	userIDStr := r.PathValue("id")
	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		utils.WriteError(w, "Invalid user ID", http.StatusBadRequest, err)
		return
	}

	completedStr := r.URL.Query().Get("completed")
	limitStr := r.URL.Query().Get("limit")
	offsetStr := r.URL.Query().Get("offset")

	var completed *bool
	if completedStr != "" {
		c, err := strconv.ParseBool(completedStr)
		if err != nil {
			utils.WriteError(w, "Invalid completed parameter", http.StatusBadRequest, err)
			return
		}
		completed = &c
	}

	var limit *int
	if limitStr != "" {
		l, err := strconv.Atoi(limitStr)
		if err != nil || l < 0 {
			utils.WriteError(w, "Invalid limit parameter", http.StatusBadRequest, err)
			return
		}
		limit = &l
	}

	var offset *int
	if offsetStr != "" {
		o, err := strconv.Atoi(offsetStr)
		if err != nil || o < 0 {
			utils.WriteError(w, "Invalid offset parameter", http.StatusBadRequest, err)
			return
		}
		offset = &o
	}

	tasks, err := h.svc.GetTasksByUserID(r.Context(), userID, completed, limit, offset)
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tasks)
}

// CreateTask creates a new task
func (h *TaskHandler) CreateTask(w http.ResponseWriter, r *http.Request) {
	var req models.CreateTaskRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	t, err := h.svc.CreateTask(r.Context(), req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidInput) {
			utils.WriteError(w, "Title and user_id are required", http.StatusBadRequest, nil)
			return
		}
		if strings.Contains(err.Error(), "foreign key") {
			utils.WriteError(w, "User not found", http.StatusBadRequest, nil)
			return
		}
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(t)
}

// CompleteTask marks a task as completed
func (h *TaskHandler) CompleteTask(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, "Invalid task ID", http.StatusBadRequest, err)
		return
	}

	t, err := h.svc.CompleteTask(r.Context(), id)
	if errors.Is(err, sql.ErrNoRows) {
		utils.WriteError(w, "Task not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(t)
}

// DeleteTask soft-deletes a task
func (h *TaskHandler) DeleteTask(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, "Invalid task ID", http.StatusBadRequest, err)
		return
	}

	err = h.svc.DeleteTask(r.Context(), id)
	if errors.Is(err, sql.ErrNoRows) {
		utils.WriteError(w, "Task not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
