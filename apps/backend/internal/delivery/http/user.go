package handlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"net/http"
	"strconv"
	"strings"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/internal/service"
	"self-management-monorepo/apps/backend/pkg/utils"
)

// UserHandler handles user-related HTTP requests
type UserHandler struct {
	svc service.UserService
}

// NewUserHandler creates a new UserHandler with the given service
func NewUserHandler(svc service.UserService) *UserHandler {
	return &UserHandler{svc: svc}
}

// GetUsers returns all users
func (h *UserHandler) GetUsers(w http.ResponseWriter, r *http.Request) {
	users, err := h.svc.GetAllUsers(r.Context())
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

	u, err := h.svc.GetUserByID(r.Context(), id)
	if errors.Is(err, sql.ErrNoRows) {
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
	var req entity.CreateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	u, err := h.svc.CreateUser(r.Context(), req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidInput) {
			utils.WriteError(w, "Invalid input", http.StatusBadRequest, nil)
			return
		}
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

	err = h.svc.DeleteUser(r.Context(), id)
	if errors.Is(err, sql.ErrNoRows) {
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

	var req entity.ModifyUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	u, err := h.svc.UpdateUser(r.Context(), id, req)
	if errors.Is(err, sql.ErrNoRows) {
		utils.WriteError(w, "User not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		if errors.Is(err, service.ErrInvalidInput) {
			utils.WriteError(w, "Invalid input", http.StatusBadRequest, nil)
			return
		}
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
	stats, err := h.svc.GetStats(r.Context())
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(stats)
}

// LoginUser authenticates a user and returns a JWT
func (h *UserHandler) LoginUser(w http.ResponseWriter, r *http.Request) {
	var req entity.LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	res, err := h.svc.Login(r.Context(), req)
	if err != nil {
		utils.WriteError(w, err.Error(), http.StatusUnauthorized, nil)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(res)
}
