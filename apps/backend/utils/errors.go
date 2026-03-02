package utils

import (
	"encoding/json"
	"log/slog"
	"net/http"
)

// ErrorResponse defines the standard structure for API errors
type ErrorResponse struct {
	Error string `json:"error"`
	Code  int    `json:"code"`
}

// WriteError logs the error internally and sends a structured JSON response to the client.
func WriteError(w http.ResponseWriter, message string, code int, err error) {
	// Log the detailed error internally
	if err != nil {
		slog.Error(message, "error", err, "code", code)
	} else {
		slog.Warn(message, "code", code)
	}

	// Send JSON response to client
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(ErrorResponse{
		Error: message,
		Code:  code,
	})
}
