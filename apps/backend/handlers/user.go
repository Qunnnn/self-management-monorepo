package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"self-management-monorepo/apps/backend/models"
	"self-management-monorepo/apps/backend/repository"
	"self-management-monorepo/apps/backend/utils"
)

// UserHandler handles user-related HTTP requests
type UserHandler struct {
	repo repository.UserRepository
}

// NewUserHandler creates a new UserHandler with the given repository
func NewUserHandler(repo repository.UserRepository) *UserHandler {
	return &UserHandler{repo: repo}
}

// GetUsers returns all users
func (h *UserHandler) GetUsers(w http.ResponseWriter, r *http.Request) {
	users, err := h.repo.GetAll(r.Context())
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(users)
}

// GetUser returns a single user by ID
func (h *UserHandler) GetUser(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, "Invalid user ID", http.StatusBadRequest, err)
		return
	}

	u, err := h.repo.GetByID(r.Context(), id)
	if err == sql.ErrNoRows {
		utils.WriteError(w, "User not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(u)
}

// CreateUser creates a new user
func (h *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
	var req models.CreateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	if req.Name == "" || req.Email == "" {
		utils.WriteError(w, "Name and email are required", http.StatusBadRequest, nil)
		return
	}

	if !utils.IsValidEmail(req.Email) {
		utils.WriteError(w, "Invalid email format", http.StatusBadRequest, nil)
		return
	}

	if !utils.IsValidPhone(req.PhoneNumber) {
		utils.WriteError(w, "Invalid phone number format", http.StatusBadRequest, nil)
		return
	}

	u, err := h.repo.Create(r.Context(), req.Name, req.Email, req.PhoneNumber, req.Password)
	if err != nil {
		if strings.Contains(err.Error(), "unique") {
			utils.WriteError(w, "Email already exists", http.StatusConflict, nil)
			return
		}
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(u)
}

// DeleteUser deletes a user by ID
func (h *UserHandler) DeleteUser(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, "Invalid user ID", http.StatusBadRequest, err)
		return
	}

	err = h.repo.Delete(r.Context(), id)
	if err == sql.ErrNoRows {
		utils.WriteError(w, "User not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// ModifyUser updates an existing user
func (h *UserHandler) ModifyUser(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, "Invalid user ID", http.StatusBadRequest, err)
		return
	}

	var req models.ModifyUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	if req.Name == "" || req.Email == "" {
		utils.WriteError(w, "Name and email are required", http.StatusBadRequest, nil)
		return
	}

	if !utils.IsValidEmail(req.Email) {
		utils.WriteError(w, "Invalid email format", http.StatusBadRequest, nil)
		return
	}

	if !utils.IsValidPhone(req.PhoneNumber) {
		utils.WriteError(w, "Invalid phone number format", http.StatusBadRequest, nil)
		return
	}

	u, err := h.repo.Update(r.Context(), id, req.Name, req.Email, req.PhoneNumber)
	if err == sql.ErrNoRows {
		utils.WriteError(w, "User not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		if strings.Contains(err.Error(), "unique") {
			utils.WriteError(w, "Email already exists", http.StatusConflict, nil)
			return
		}
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(u)
}

// GetUserStats returns an overview of total users and active tasks
func (h *UserHandler) GetUserStats(w http.ResponseWriter, r *http.Request) {
	stats, err := h.repo.GetStats(r.Context())
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(stats)
}
