package handlers_test

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"self-management-monorepo/apps/backend/handlers"
	"self-management-monorepo/apps/backend/models"
)

// MockUserService is a manual mock of the UserService interface
type MockUserService struct {
	GetAllUsersFunc func(ctx context.Context) ([]models.User, error)
	GetUserByIDFunc func(ctx context.Context, id int) (*models.User, error)
	CreateUserFunc  func(ctx context.Context, req models.CreateUserRequest) (*models.User, error)
	UpdateUserFunc  func(ctx context.Context, id int, req models.ModifyUserRequest) (*models.User, error)
	DeleteUserFunc  func(ctx context.Context, id int) error
	GetStatsFunc    func(ctx context.Context) (*models.UserStats, error)
}

func (m *MockUserService) GetAllUsers(ctx context.Context) ([]models.User, error) {
	return m.GetAllUsersFunc(ctx)
}
func (m *MockUserService) GetUserByID(ctx context.Context, id int) (*models.User, error) {
	return m.GetUserByIDFunc(ctx, id)
}
func (m *MockUserService) CreateUser(ctx context.Context, req models.CreateUserRequest) (*models.User, error) {
	return m.CreateUserFunc(ctx, req)
}
func (m *MockUserService) UpdateUser(ctx context.Context, id int, req models.ModifyUserRequest) (*models.User, error) {
	return m.UpdateUserFunc(ctx, id, req)
}
func (m *MockUserService) DeleteUser(ctx context.Context, id int) error {
	return m.DeleteUserFunc(ctx, id)
}
func (m *MockUserService) GetStats(ctx context.Context) (*models.UserStats, error) {
	return m.GetStatsFunc(ctx)
}

func TestGetUser(t *testing.T) {
	mockSvc := &MockUserService{
		GetUserByIDFunc: func(ctx context.Context, id int) (*models.User, error) {
			return &models.User{
				ID:        1,
				Name:      "Test User",
				Email:     "test@user.com",
				CreatedAt: time.Now(),
			}, nil
		},
	}

	h := handlers.NewUserHandler(mockSvc)

	req := httptest.NewRequest("GET", "/users/1", nil)
	req.SetPathValue("id", "1")
	w := httptest.NewRecorder()

	h.GetUser(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status OK, got %v", w.Code)
	}

	var user models.User
	if err := json.NewDecoder(w.Body).Decode(&user); err != nil {
		t.Fatal("Failed to decode response")
	}

	if user.Name != "Test User" {
		t.Errorf("Expected 'Test User', got %q", user.Name)
	}
}
