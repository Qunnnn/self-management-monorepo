package service

import (
	"context"
	"errors"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/pkg/utils"
)

var (
	ErrUserNotFound       = errors.New("user not found")
	ErrEmailAlreadyExists = errors.New("email already exists")
	ErrInvalidInput       = errors.New("invalid input")
)

// UserService defines business logic for users
type UserService interface {
	GetAllUsers(ctx context.Context) ([]entity.User, error)
	GetUserByID(ctx context.Context, id string) (*entity.User, error)
	UpdateUser(ctx context.Context, id string, req entity.ModifyUserRequest) (*entity.User, error)
	DeleteUser(ctx context.Context, id string) error
	GetStats(ctx context.Context) (*entity.UserStats, error)
}

type userService struct {
	repo UserRepository
}

func NewUserService(repo UserRepository) UserService {
	return &userService{repo: repo}
}

func (s *userService) GetAllUsers(ctx context.Context) ([]entity.User, error) {
	return s.repo.GetAll(ctx)
}

func (s *userService) GetUserByID(ctx context.Context, id string) (*entity.User, error) {
	user, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return user, nil
}

func (s *userService) UpdateUser(ctx context.Context, id string, req entity.ModifyUserRequest) (*entity.User, error) {
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

func (s *userService) DeleteUser(ctx context.Context, id string) error {
	return s.repo.Delete(ctx, id)
}

func (s *userService) GetStats(ctx context.Context) (*entity.UserStats, error) {
	return s.repo.GetStats(ctx)
}

