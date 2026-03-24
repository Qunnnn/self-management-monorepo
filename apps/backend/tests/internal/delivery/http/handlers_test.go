package handlers_test

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	handlers "self-management-monorepo/apps/backend/internal/delivery/http"
	"self-management-monorepo/apps/backend/internal/entity"
)

// MockUserService is a manual mock of the UserService interface
type MockUserService struct {
	GetAllUsersFunc func(ctx context.Context) ([]entity.User, error)
	GetUserByIDFunc func(ctx context.Context, id string) (*entity.User, error)
	UpdateUserFunc  func(ctx context.Context, id string, req entity.ModifyUserRequest) (*entity.User, error)
	DeleteUserFunc  func(ctx context.Context, id string) error
	GetStatsFunc    func(ctx context.Context) (*entity.UserStats, error)
}

func (m *MockUserService) GetAllUsers(ctx context.Context) ([]entity.User, error) {
	return m.GetAllUsersFunc(ctx)
}
func (m *MockUserService) GetUserByID(ctx context.Context, id string) (*entity.User, error) {
	return m.GetUserByIDFunc(ctx, id)
}
func (m *MockUserService) UpdateUser(ctx context.Context, id string, req entity.ModifyUserRequest) (*entity.User, error) {
	return m.UpdateUserFunc(ctx, id, req)
}
func (m *MockUserService) DeleteUser(ctx context.Context, id string) error {
	return m.DeleteUserFunc(ctx, id)
}
func (m *MockUserService) GetStats(ctx context.Context) (*entity.UserStats, error) {
	return m.GetStatsFunc(ctx)
}

func TestGetUser(t *testing.T) {
	mockSvc := &MockUserService{
		GetUserByIDFunc: func(ctx context.Context, id string) (*entity.User, error) {
			return &entity.User{
				ID:        "1",
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

	var user entity.User
	if err := json.NewDecoder(w.Body).Decode(&user); err != nil {
		t.Fatal("Failed to decode response")
	}

	if user.Name != "Test User" {
		t.Errorf("Expected 'Test User', got %q", user.Name)
	}
}
