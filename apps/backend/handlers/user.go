package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"self-management-monorepo/apps/backend/db"
	"self-management-monorepo/apps/backend/models"
	"self-management-monorepo/apps/backend/utils"
)

// GetUsers returns all users
func GetUsers(w http.ResponseWriter, r *http.Request) {
	rows, err := db.DB.Query("SELECT id, name, email, phone_number, created_at FROM users ORDER BY id")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var users []models.User
	for rows.Next() {
		var u models.User
		var phone sql.NullString
		if err := rows.Scan(&u.ID, &u.Name, &u.Email, &phone, &u.CreatedAt); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		if phone.Valid {
			u.PhoneNumber = phone.String
		}
		users = append(users, u)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(users)
}

// GetUser returns a single user by ID
func GetUser(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	var u models.User
	var phone sql.NullString
	err = db.DB.QueryRow(
		"SELECT id, name, email, phone_number, created_at FROM users WHERE id = $1",
		id,
	).Scan(&u.ID, &u.Name, &u.Email, &phone, &u.CreatedAt)

	if err == sql.ErrNoRows {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if phone.Valid {
		u.PhoneNumber = phone.String
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(u)
}

// CreateUser creates a new user
func CreateUser(w http.ResponseWriter, r *http.Request) {
	var req models.CreateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.Name == "" || req.Email == "" {
		http.Error(w, "Name and email are required", http.StatusBadRequest)
		return
	}

	if !utils.IsValidEmail(req.Email) {
		http.Error(w, "Invalid email format", http.StatusBadRequest)
		return
	}

	if !utils.IsValidPhone(req.PhoneNumber) {
		http.Error(w, "Invalid phone number format", http.StatusBadRequest)
		return
	}

	phone := utils.ToNullString(req.PhoneNumber)

	var u models.User
	var resPhone sql.NullString
	err := db.DB.QueryRow(
		"INSERT INTO users (name, email, phone_number, password) VALUES ($1, $2, $3, $4) RETURNING id, name, email, phone_number, created_at",
		req.Name, req.Email, phone, req.Password,
	).Scan(&u.ID, &u.Name, &u.Email, &resPhone, &u.CreatedAt)

	if err != nil {
		// Check for unique constraint violation
		if strings.Contains(err.Error(), "unique") {
			http.Error(w, "Email already exists", http.StatusConflict)
			return
		}
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if resPhone.Valid {
		u.PhoneNumber = resPhone.String
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(u)
}

// DeleteUser deletes a user by ID
func DeleteUser(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	result, err := db.DB.Exec("DELETE FROM users WHERE id = $1", id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// ModifyUser updates an existing user
func ModifyUser(w http.ResponseWriter, r *http.Request) {
	idStr := r.PathValue("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	var req models.ModifyUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if req.Name == "" || req.Email == "" {
		http.Error(w, "Name and email are required", http.StatusBadRequest)
		return
	}

	if !utils.IsValidEmail(req.Email) {
		http.Error(w, "Invalid email format", http.StatusBadRequest)
		return
	}

	if !utils.IsValidPhone(req.PhoneNumber) {
		http.Error(w, "Invalid phone number format", http.StatusBadRequest)
		return
	}

	phone := utils.ToNullString(req.PhoneNumber)

	var u models.User
	var resPhone sql.NullString

	err = db.DB.QueryRow(
		"UPDATE users SET name = $1, email = $2, phone_number = $3 WHERE id = $4 RETURNING id, name, email, phone_number, created_at",
		req.Name, req.Email, phone, id,
	).Scan(&u.ID, &u.Name, &u.Email, &resPhone, &u.CreatedAt)

	if err == sql.ErrNoRows {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	if err != nil {
		if strings.Contains(err.Error(), "unique") {
			http.Error(w, "Email already exists", http.StatusConflict)
			return
		}
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if resPhone.Valid {
		u.PhoneNumber = resPhone.String
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(u)
}

// GetUserStats returns an overview of total users and active tasks
func GetUserStats(w http.ResponseWriter, r *http.Request) {
	var stats models.UserStats

	// Count total users
	err := db.DB.QueryRow("SELECT COUNT(*) FROM users").Scan(&stats.TotalUsers)
	if err != nil {
		http.Error(w, "Failed to count users: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// Count active tasks (not completed and not deleted)
	err = db.DB.QueryRow("SELECT COUNT(*) FROM tasks WHERE is_completed = false AND deleted_at IS NULL").Scan(&stats.ActiveTasks)
	if err != nil {
		http.Error(w, "Failed to count active tasks: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(stats)
}
