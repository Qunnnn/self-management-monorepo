package service

import (
	"context"
	"errors"
	"self-management-monorepo/apps/backend/models"
	"self-management-monorepo/apps/backend/repository"
	"self-management-monorepo/apps/backend/utils"
)

var (
	ErrUserNotFound       = errors.New("user not found")
	ErrEmailAlreadyExists = errors.New("email already exists")
	ErrInvalidInput       = errors.New("invalid input")
)

// UserService defines business logic for users
type UserService interface {
	GetAllUsers(ctx context.Context) ([]models.User, error)
	GetUserByID(ctx context.Context, id int) (*models.User, error)
	CreateUser(ctx context.Context, req models.CreateUserRequest) (*models.User, error)
	UpdateUser(ctx context.Context, id int, req models.ModifyUserRequest) (*models.User, error)
	DeleteUser(ctx context.Context, id int) error
	GetStats(ctx context.Context) (*models.UserStats, error)
}

type userService struct {
	repo repository.UserRepository
}

func NewUserService(repo repository.UserRepository) UserService {
	return &userService{repo: repo}
}

func (s *userService) GetAllUsers(ctx context.Context) ([]models.User, error) {
	return s.repo.GetAll(ctx)
}

func (s *userService) GetUserByID(ctx context.Context, id int) (*models.User, error) {
	user, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return user, nil
}

func (s *userService) CreateUser(ctx context.Context, req models.CreateUserRequest) (*models.User, error) {
	if req.Name == "" || req.Email == "" {
		return nil, ErrInvalidInput
	}
	if !utils.IsValidEmail(req.Email) {
		return nil, ErrInvalidInput
	}
	if !utils.IsValidPhone(req.PhoneNumber) {
		return nil, ErrInvalidInput
	}

	return s.repo.Create(ctx, req.Name, req.Email, req.PhoneNumber, req.Password)
}

func (s *userService) UpdateUser(ctx context.Context, id int, req models.ModifyUserRequest) (*models.User, error) {
	if req.Name == "" || req.Email == "" {
		return nil, ErrInvalidInput
	}
	if !utils.IsValidEmail(req.Email) {
		return nil, ErrInvalidInput
	}
	if !utils.IsValidPhone(req.PhoneNumber) {
		return nil, ErrInvalidInput
	}

	return s.repo.Update(ctx, id, req.Name, req.Email, req.PhoneNumber)
}

func (s *userService) DeleteUser(ctx context.Context, id int) error {
	return s.repo.Delete(ctx, id)
}

func (s *userService) GetStats(ctx context.Context) (*models.UserStats, error) {
	return s.repo.GetStats(ctx)
}
