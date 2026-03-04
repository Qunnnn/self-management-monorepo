package handlers

import (
	"net/http"
)

// New initializes and returns a new HTTP multiplexer with all application routes registered.
func New(userH *UserHandler, taskH *TaskHandler) *http.ServeMux {
	mux := http.NewServeMux()

	// User routes
	mux.HandleFunc("GET /users/stats", userH.GetUserStats)
	mux.HandleFunc("GET /users", userH.GetUsers)
	mux.HandleFunc("POST /users", userH.CreateUser)
	mux.HandleFunc("GET /users/{id}", userH.GetUser)
	mux.HandleFunc("PUT /users/{id}", userH.ModifyUser)
	mux.HandleFunc("DELETE /users/{id}", userH.DeleteUser)
	mux.HandleFunc("GET /users/{id}/tasks", taskH.GetTasksByUser)

	// Task routes
	mux.HandleFunc("GET /tasks", taskH.GetTasks)
	mux.HandleFunc("POST /tasks", taskH.CreateTask)
	mux.HandleFunc("GET /tasks/{id}", taskH.GetTask)
	mux.HandleFunc("DELETE /tasks/{id}", taskH.DeleteTask)
	mux.HandleFunc("POST /tasks/{id}/complete", taskH.CompleteTask)
	mux.HandleFunc("PATCH /tasks/{id}/complete", taskH.CompleteTask)

	// Health check
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("OK"))
	})

	return mux
}
