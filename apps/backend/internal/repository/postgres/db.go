package postgres

import (
	"database/sql"
	"fmt"
	"log/slog"

	_ "github.com/lib/pq"
)

var DB *sql.DB

// Config holds database connection parameters
type Config struct {
	Host     string
	Port     int
	User     string
	Password string
	DBName   string
}

// Connect establishes a connection to PostgreSQL
func Connect(cfg Config) error {
	var connStr string
	if cfg.Password == "" {
		// For local socket connection (no password)
		connStr = fmt.Sprintf(
			"host=%s user=%s dbname=%s sslmode=disable",
			cfg.Host, cfg.User, cfg.DBName,
		)
	} else {
		connStr = fmt.Sprintf(
			"host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
			cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.DBName,
		)
	}

	var err error
	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		return fmt.Errorf("failed to open database: %w", err)
	}

	// Test the connection
	if err = DB.Ping(); err != nil {
		return fmt.Errorf("failed to ping database: %w", err)
	}

	slog.Info("Connected to PostgreSQL successfully!")
	return nil
}

// Close closes the database connection
func Close() {
	if DB != nil {
		DB.Close()
	}
}
