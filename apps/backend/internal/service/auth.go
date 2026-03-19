package service

import (
	"context"
	"errors"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/pkg/utils"

	"golang.org/x/crypto/bcrypt"
)

type AuthService interface {
	Register(ctx context.Context, req entity.CreateUserRequest) (*entity.User, error)
	Login(ctx context.Context, req entity.LoginRequest) (*entity.AuthResponse, error)
}

type authService struct {
	repo UserRepository
}

func NewAuthService(repo UserRepository) AuthService {
	return &authService{repo: repo}
}

func (s *authService) Register(ctx context.Context, req entity.CreateUserRequest) (*entity.User, error) {
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

func (s *authService) Login(ctx context.Context, req entity.LoginRequest) (*entity.AuthResponse, error) {
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

	return &entity.AuthResponse{
		User:  user,
		Token: tokenStr,
	}, nil
}
