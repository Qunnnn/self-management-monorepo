package integration

import (
	"context"
	"database/sql"
	"os"
	"testing"

	"self-management-monorepo/apps/backend/repository"

	_ "github.com/lib/pq"
)

func TestUserIntegration(t *testing.T) {
	dbURL := os.Getenv("TEST_DB_URL")
	if dbURL == "" {
		t.Skip("Skipping integration test: TEST_DB_URL not set")
	}

	db, err := sql.Open("postgres", dbURL)
	if err != nil {
		t.Fatalf("Failed to open test database: %v", err)
	}
	defer db.Close()

	repo := repository.NewUserRepository(db)
	ctx := context.Background()

	t.Run("Create and Get User", func(t *testing.T) {
		email := "integration@example.com"
		name := "Integration Test"

		db.Exec("DELETE FROM users WHERE email = $1", email)

		user, err := repo.Create(ctx, name, email, "", "password123")
		if err != nil {
			t.Fatalf("Failed to create user: %v", err)
		}

		if user.Name != name {
			t.Errorf("Expected name %q, got %q", name, user.Name)
		}

		fetched, err := repo.GetByID(ctx, user.ID)
		if err != nil {
			t.Fatalf("Failed to fetch user: %v", err)
		}

		if fetched.Email != email {
			t.Errorf("Expected email %q, got %q", email, fetched.Email)
		}

		err = repo.Delete(ctx, user.ID)
		if err != nil {
			t.Errorf("Failed to delete user: %v", err)
		}
	})
}
