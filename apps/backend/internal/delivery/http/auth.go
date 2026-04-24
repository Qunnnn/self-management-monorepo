package handlers

import (
	"encoding/json"
	"errors"
	"net/http"
	"strings"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/internal/service"
	"self-management-monorepo/apps/backend/pkg/utils"
)

type AuthHandler struct {
	svc service.AuthService
}

func NewAuthHandler(svc service.AuthService) *AuthHandler {
	return &AuthHandler{svc: svc}
}

// Register creates a new user via registration
func (h *AuthHandler) Register(w http.ResponseWriter, r *http.Request) {
	var req entity.CreateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	res, err := h.svc.Register(r.Context(), req)
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
	json.NewEncoder(w).Encode(res)
}

// Login authenticates a user and returns a JWT
func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
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

// Refresh handles token refresh requests
func (h *AuthHandler) Refresh(w http.ResponseWriter, r *http.Request) {
	var req entity.RefreshRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	res, err := h.svc.RefreshToken(r.Context(), req.RefreshToken)
	if err != nil {
		utils.WriteError(w, err.Error(), http.StatusUnauthorized, nil)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(res)
}

// ForgotPassword requests a password reset
func (h *AuthHandler) ForgotPassword(w http.ResponseWriter, r *http.Request) {
	var req entity.ForgotPasswordRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	if err := h.svc.ForgotPassword(r.Context(), req); err != nil {
		utils.WriteError(w, "Failed to process request", http.StatusInternalServerError, err)
		return
	}

	w.WriteHeader(http.StatusOK)
}

// ResetPassword resets the password using a token
func (h *AuthHandler) ResetPassword(w http.ResponseWriter, r *http.Request) {
	var req entity.ResetPasswordRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	if err := h.svc.ResetPassword(r.Context(), req); err != nil {
		utils.WriteError(w, err.Error(), http.StatusBadRequest, nil)
		return
	}

	w.WriteHeader(http.StatusOK)
}
