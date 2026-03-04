package main

import (
	"log/slog"
	"net/http"
	"os"

	"self-management-monorepo/apps/backend/internal/repository/postgres"
	"self-management-monorepo/apps/backend/internal/service"

	httpHandlers "self-management-monorepo/apps/backend/internal/delivery/http"
)

func main() {
	// Set up structured logging
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	// Database configuration
	cfg := postgres.Config{
		Host:     "/tmp", // Unix socket path for local PostgreSQL
		Port:     5432,
		User:     "qun", // Your PostgreSQL username
		Password: "",    // Empty for local socket connection
		DBName:   "pg_learning",
	}

	// Connect to database
	if err := postgres.Connect(cfg); err != nil {
		slog.Error("Failed to connect to database", "error", err)
		os.Exit(1)
	}
	defer postgres.Close()

	// Initialize repositories
	userRepo := postgres.NewUserRepository(postgres.DB)
	taskRepo := postgres.NewTaskRepository(postgres.DB)

	// Initialize services
	userSvc := service.NewUserService(userRepo)
	taskSvc := service.NewTaskService(taskRepo)

	// Initialize handlers
	userHandler := httpHandlers.NewUserHandler(userSvc)
	taskHandler := httpHandlers.NewTaskHandler(taskSvc)

	// Create router
	mux := httpHandlers.New(userHandler, taskHandler)

	// Wrap router with logging middleware
	handler := httpHandlers.LoggingMiddleware(mux)

	slog.Info("Server starting", "url", "http://localhost:8080")
	if err := http.ListenAndServe(":8080", handler); err != nil {
		slog.Error("Server crashed", "error", err)
		os.Exit(1)
	}
}
