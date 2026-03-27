package handlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"net/http"
	"strconv"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/internal/service"
	"self-management-monorepo/apps/backend/pkg/utils"
)

// DiaryHandler handles diary-related HTTP requests
type DiaryHandler struct {
	svc service.DiaryService
}

// NewDiaryHandler creates a new DiaryHandler with the given service
func NewDiaryHandler(svc service.DiaryService) *DiaryHandler {
	return &DiaryHandler{svc: svc}
}

// GetDiaryEntries returns all active diary entries for a user
func (h *DiaryHandler) GetDiaryEntries(w http.ResponseWriter, r *http.Request) {
	userID := r.PathValue("userId")
	if userID == "" {
		utils.WriteError(w, "Invalid user ID", http.StatusBadRequest, nil)
		return
	}

	limitStr := r.URL.Query().Get("limit")
	offsetStr := r.URL.Query().Get("offset")

	var limit *int
	if limitStr != "" {
		l, err := strconv.Atoi(limitStr)
		if err == nil && l >= 0 {
			limit = &l
		}
	}

	var offset *int
	if offsetStr != "" {
		o, err := strconv.Atoi(offsetStr)
		if err == nil && o >= 0 {
			offset = &o
		}
	}

	entries, err := h.svc.GetDiaryEntries(r.Context(), userID, limit, offset)
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(entries)
}

// GetDiaryEntry returns a single diary entry by ID
func (h *DiaryHandler) GetDiaryEntry(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		utils.WriteError(w, "Invalid diary ID", http.StatusBadRequest, nil)
		return
	}

	e, err := h.svc.GetDiaryEntry(r.Context(), id)
	if errors.Is(err, sql.ErrNoRows) {
		utils.WriteError(w, "Diary entry not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(e)
}

// CreateDiaryEntry creates a new diary entry
func (h *DiaryHandler) CreateDiaryEntry(w http.ResponseWriter, r *http.Request) {
	var req entity.CreateDiaryEntryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	e, err := h.svc.CreateDiaryEntry(r.Context(), req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidInput) {
			utils.WriteError(w, "User ID and content are required", http.StatusBadRequest, nil)
			return
		}
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(e)
}

// UpdateDiaryEntry updates an existing diary entry
func (h *DiaryHandler) UpdateDiaryEntry(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		utils.WriteError(w, "Invalid diary ID", http.StatusBadRequest, nil)
		return
	}

	var req entity.UpdateDiaryEntryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	e, err := h.svc.UpdateDiaryEntry(r.Context(), id, req)
	if errors.Is(err, sql.ErrNoRows) {
		utils.WriteError(w, "Diary entry not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(e)
}

// DeleteDiaryEntry soft-deletes a diary entry
func (h *DiaryHandler) DeleteDiaryEntry(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		utils.WriteError(w, "Invalid diary ID", http.StatusBadRequest, nil)
		return
	}

	err := h.svc.DeleteDiaryEntry(r.Context(), id)
	if errors.Is(err, sql.ErrNoRows) {
		utils.WriteError(w, "Diary entry not found", http.StatusNotFound, nil)
		return
	}
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// GetAttachments returns all attachments for a diary entry
func (h *DiaryHandler) GetAttachments(w http.ResponseWriter, r *http.Request) {
	entryID := r.PathValue("id")
	if entryID == "" {
		utils.WriteError(w, "Invalid diary ID", http.StatusBadRequest, nil)
		return
	}

	attachments, err := h.svc.GetAttachments(r.Context(), entryID)
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(attachments)
}

// AddAttachment adds a new attachment to a diary entry
func (h *DiaryHandler) AddAttachment(w http.ResponseWriter, r *http.Request) {
	entryID := r.PathValue("id")
	if entryID == "" {
		utils.WriteError(w, "Invalid diary ID", http.StatusBadRequest, nil)
		return
	}

	var req struct {
		FileURL  string  `json:"fileUrl"`
		FileType *string `json:"fileType"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, "Invalid request body", http.StatusBadRequest, err)
		return
	}

	a, err := h.svc.AddAttachment(r.Context(), entryID, req.FileURL, req.FileType)
	if err != nil {
		utils.WriteError(w, "Internal server error", http.StatusInternalServerError, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(a)
}
