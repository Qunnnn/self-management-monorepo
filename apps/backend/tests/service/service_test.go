package service_test

import (
	"context"
	"errors"
	"testing"

	"self-management-monorepo/apps/backend/models"
	"self-management-monorepo/apps/backend/service"
)

// MockUserRepository is a manual mock of the UserRepository interface
type MockUserRepository struct {
	GetAllFunc   func(ctx context.Context) ([]models.User, error)
	GetByIDFunc  func(ctx context.Context, id int) (*models.User, error)
	CreateFunc   func(ctx context.Context, name, email, phone, password string) (*models.User, error)
	UpdateFunc   func(ctx context.Context, id int, name, email, phone string) (*models.User, error)
	DeleteFunc   func(ctx context.Context, id int) error
	GetStatsFunc func(ctx context.Context) (*models.UserStats, error)
}

func (m *MockUserRepository) GetAll(ctx context.Context) ([]models.User, error) {
	return m.GetAllFunc(ctx)
}
func (m *MockUserRepository) GetByID(ctx context.Context, id int) (*models.User, error) {
	return m.GetByIDFunc(ctx, id)
}
func (m *MockUserRepository) Create(ctx context.Context, name, email, phone, password string) (*models.User, error) {
	return m.CreateFunc(ctx, name, email, phone, password)
}
func (m *MockUserRepository) Update(ctx context.Context, id int, name, email, phone string) (*models.User, error) {
	return m.UpdateFunc(ctx, id, name, email, phone)
}
func (m *MockUserRepository) Delete(ctx context.Context, id int) error {
	return m.DeleteFunc(ctx, id)
}
func (m *MockUserRepository) GetStats(ctx context.Context) (*models.UserStats, error) {
	return m.GetStatsFunc(ctx)
}

func TestCreateUserValidation(t *testing.T) {
	mockRepo := &MockUserRepository{}
	s := service.NewUserService(mockRepo)
	ctx := context.Background()

	t.Run("Empty Name", func(t *testing.T) {
		req := models.CreateUserRequest{Email: "test@test.com"}
		_, err := s.CreateUser(ctx, req)
		if !errors.Is(err, service.ErrInvalidInput) {
			t.Errorf("Expected ErrInvalidInput, got %v", err)
		}
	})

	t.Run("Invalid Email", func(t *testing.T) {
		req := models.CreateUserRequest{Name: "Name", Email: "invalid"}
		_, err := s.CreateUser(ctx, req)
		if !errors.Is(err, service.ErrInvalidInput) {
			t.Errorf("Expected ErrInvalidInput, got %v", err)
		}
	})
}
