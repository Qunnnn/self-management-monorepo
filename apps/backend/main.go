package main

import (
	"log"
	"net/http"

	"self-management-monorepo/apps/backend/db"
	"self-management-monorepo/apps/backend/router"
)

func main() {
	// Database configuration
	// For local development, PostgreSQL typically uses your system username
	// with no password when connecting via socket
	cfg := db.Config{
		Host:     "/tmp", // Unix socket path for local PostgreSQL
		Port:     5432,
		User:     "qun", // Your PostgreSQL username
		Password: "",    // Empty for local socket connection
		DBName:   "pg_learning",
	}

	// Connect to database
	if err := db.Connect(cfg); err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer db.Close()

	mux := router.New()

	log.Println("Server starting on http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", mux))
}
