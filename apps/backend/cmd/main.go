package main

import (
	"log/slog"
	"net/http"
	"os"
	"strconv"

	"github.com/joho/godotenv"

	"self-management-monorepo/apps/backend/internal/middleware"
	"self-management-monorepo/apps/backend/internal/repository/postgres"
	"self-management-monorepo/apps/backend/internal/service"

	httpHandlers "self-management-monorepo/apps/backend/internal/delivery/http"
)

func main() {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		slog.Warn("No .env file found, relying on environment variables")
	}

	// Set up structured logging based on environment
	var handler slog.Handler
	if os.Getenv("APP_ENV") == "development" {
		handler = slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelDebug})
	} else {
		handler = slog.NewJSONHandler(os.Stdout, nil)
	}
	logger := slog.New(handler)
	slog.SetDefault(logger)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	dbPort, _ := strconv.Atoi(os.Getenv("DB_PORT"))
	if dbPort == 0 {
		dbPort = 5432
	}

	// Database configuration
	cfg := postgres.Config{
		Host:     os.Getenv("DB_HOST"),
		Port:     dbPort,
		User:     os.Getenv("DB_USER"),
		Password: os.Getenv("DB_PASSWORD"),
		DBName:   os.Getenv("DB_NAME"),
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
	h := middleware.LoggingMiddleware(mux)

	slog.Info("Server starting", "url", "http://localhost:"+port)
	if err := http.ListenAndServe(":"+port, h); err != nil {
		slog.Error("Server crashed", "error", err)
		os.Exit(1)
	}
}
