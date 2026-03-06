package service

import (
	"context"
	"errors"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/pkg/utils"

	"golang.org/x/crypto/bcrypt"
)

var (
	ErrUserNotFound       = errors.New("user not found")
	ErrEmailAlreadyExists = errors.New("email already exists")
	ErrInvalidInput       = errors.New("invalid input")
)

// UserService defines business logic for users
type UserService interface {
	GetAllUsers(ctx context.Context) ([]entity.User, error)
	GetUserByID(ctx context.Context, id int) (*entity.User, error)
	CreateUser(ctx context.Context, req entity.CreateUserRequest) (*entity.User, error)
	UpdateUser(ctx context.Context, id int, req entity.ModifyUserRequest) (*entity.User, error)
	DeleteUser(ctx context.Context, id int) error
	GetStats(ctx context.Context) (*entity.UserStats, error)
	Login(ctx context.Context, req entity.LoginRequest) (*entity.AuthResponse, error)
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

func (s *userService) GetUserByID(ctx context.Context, id int) (*entity.User, error) {
	user, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return user, nil
}

func (s *userService) CreateUser(ctx context.Context, req entity.CreateUserRequest) (*entity.User, error) {
	if req.Name == "" || req.Email == "" {
		return nil, ErrInvalidInput
	}
	if !utils.IsValidEmail(req.Email) {
		return nil, ErrInvalidInput
	}
	if !utils.IsValidPhone(req.PhoneNumber) {
		return nil, ErrInvalidInput
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	return s.repo.Create(ctx, req.Name, req.Email, req.PhoneNumber, string(hashedPassword))
}

func (s *userService) UpdateUser(ctx context.Context, id int, req entity.ModifyUserRequest) (*entity.User, error) {
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

func (s *userService) GetStats(ctx context.Context) (*entity.UserStats, error) {
	return s.repo.GetStats(ctx)
}

func (s *userService) Login(ctx context.Context, req entity.LoginRequest) (*entity.AuthResponse, error) {
	user, err := s.repo.GetByEmail(ctx, req.Email)
	if err != nil {
		// To avoid timing attacks or exposing if an email exists, return a generic error
		return nil, errors.New("invalid email or password")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password))
	if err != nil {
		return nil, errors.New("invalid email or password")
	}

	tokenStr, err := utils.GenerateJWT(user.ID)
	if err != nil {
		return nil, err
	}

	return &entity.AuthResponse{Token: tokenStr}, nil
}
