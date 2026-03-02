package router

import (
	"net/http"

	"self-management-monorepo/apps/backend/handlers"
)

// New initializes and returns a new HTTP multiplexer with all application routes registered.
func New() *http.ServeMux {
	mux := http.NewServeMux()

	// User routes
	mux.HandleFunc("GET /users/stats", handlers.GetUserStats)
	mux.HandleFunc("GET /users", handlers.GetUsers)
	mux.HandleFunc("POST /users", handlers.CreateUser)
	mux.HandleFunc("GET /users/{id}", handlers.GetUser)
	mux.HandleFunc("PUT /users/{id}", handlers.ModifyUser)
	mux.HandleFunc("DELETE /users/{id}", handlers.DeleteUser)
	mux.HandleFunc("GET /users/{id}/tasks", handlers.GetTasksByUser)

	// Task routes
	mux.HandleFunc("GET /tasks", handlers.GetTasks)
	mux.HandleFunc("POST /tasks", handlers.CreateTask)
	mux.HandleFunc("GET /tasks/{id}", handlers.GetTask)
	mux.HandleFunc("DELETE /tasks/{id}", handlers.DeleteTask)
	mux.HandleFunc("POST /tasks/{id}/complete", handlers.CompleteTask)
	mux.HandleFunc("PATCH /tasks/{id}/complete", handlers.CompleteTask)

	// Health check
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("OK"))
	})

	return mux
}
