package main

import (
	"log/slog"
	"net/http"
	"os"

	"self-management-monorepo/apps/backend/db"
	"self-management-monorepo/apps/backend/handlers"
	"self-management-monorepo/apps/backend/middleware"
	"self-management-monorepo/apps/backend/repository"
	"self-management-monorepo/apps/backend/router"
	"self-management-monorepo/apps/backend/service"
)

func main() {
	// Set up structured logging
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	// Database configuration
	cfg := db.Config{
		Host:     "/tmp", // Unix socket path for local PostgreSQL
		Port:     5432,
		User:     "qun", // Your PostgreSQL username
		Password: "",    // Empty for local socket connection
		DBName:   "pg_learning",
	}

	// Connect to database
	if err := db.Connect(cfg); err != nil {
		slog.Error("Failed to connect to database", "error", err)
		os.Exit(1)
	}
	defer db.Close()

	// Initialize repositories
	userRepo := repository.NewUserRepository(db.DB)
	taskRepo := repository.NewTaskRepository(db.DB)

	// Initialize services (New Layer!)
	userSvc := service.NewUserService(userRepo)
	taskSvc := service.NewTaskService(taskRepo)

	// Initialize handlers
	userHandler := handlers.NewUserHandler(userSvc)
	taskHandler := handlers.NewTaskHandler(taskSvc)

	// Create router
	mux := router.New(userHandler, taskHandler)

	// Wrap router with logging middleware
	handler := middleware.LoggingMiddleware(mux)

	slog.Info("Server starting", "url", "http://localhost:8080")
	if err := http.ListenAndServe(":8080", handler); err != nil {
		slog.Error("Server crashed", "error", err)
		os.Exit(1)
	}
}
