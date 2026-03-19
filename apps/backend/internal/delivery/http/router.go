package handlers

import (
	"net/http"

	"self-management-monorepo/apps/backend/internal/middleware"
)

// New initializes and returns a new HTTP multiplexer with all application routes registered.
func New(authH *AuthHandler, userH *UserHandler, taskH *TaskHandler) *http.ServeMux {
	mux := http.NewServeMux()

	// Public routes
	mux.HandleFunc("POST /auth/login", authH.Login)
	mux.HandleFunc("POST /auth/register", authH.Register)
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("OK"))
	})

	mux.Handle("GET /users/stats", middleware.AuthMiddleware(http.HandlerFunc(userH.GetUserStats)))
	mux.Handle("GET /users", middleware.AuthMiddleware(http.HandlerFunc(userH.GetUsers)))
	mux.Handle("GET /users/{id}", middleware.AuthMiddleware(http.HandlerFunc(userH.GetUser)))
	mux.Handle("PUT /users/{id}", middleware.AuthMiddleware(http.HandlerFunc(userH.ModifyUser)))
	mux.Handle("DELETE /users/{id}", middleware.AuthMiddleware(http.HandlerFunc(userH.DeleteUser)))
	mux.Handle("GET /users/{id}/tasks", middleware.AuthMiddleware(http.HandlerFunc(taskH.GetTasksByUser)))

	mux.Handle("GET /tasks", middleware.AuthMiddleware(http.HandlerFunc(taskH.GetTasks)))
	mux.Handle("POST /tasks", middleware.AuthMiddleware(http.HandlerFunc(taskH.CreateTask)))
	mux.Handle("GET /tasks/{id}", middleware.AuthMiddleware(http.HandlerFunc(taskH.GetTask)))
	mux.Handle("DELETE /tasks/{id}", middleware.AuthMiddleware(http.HandlerFunc(taskH.DeleteTask)))
	mux.Handle("POST /tasks/{id}/complete", middleware.AuthMiddleware(http.HandlerFunc(taskH.CompleteTask)))
	mux.Handle("PATCH /tasks/{id}/complete", middleware.AuthMiddleware(http.HandlerFunc(taskH.CompleteTask)))

	return mux
}
