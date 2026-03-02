package main

import (
	"log/slog"
	"net/http"
	"os"

	"self-management-monorepo/apps/backend/db"
	"self-management-monorepo/apps/backend/router"
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

	mux := router.New()

	slog.Info("Server starting", "url", "http://localhost:8080")
	if err := http.ListenAndServe(":8080", mux); err != nil {
		slog.Error("Server crashed", "error", err)
		os.Exit(1)
	}
}
