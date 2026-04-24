package service

import (
	"context"
	"errors"
	"log/slog"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/pkg/constants"
	"self-management-monorepo/apps/backend/pkg/utils"

	"golang.org/x/crypto/bcrypt"
)

type AuthService interface {
	Register(ctx context.Context, req entity.CreateUserRequest) (*entity.AuthResponse, error)
	Login(ctx context.Context, req entity.LoginRequest) (*entity.AuthResponse, error)
	RefreshToken(ctx context.Context, refreshToken string) (*entity.AuthResponse, error)
}

type authService struct {
	repo UserRepository
}

func NewAuthService(repo UserRepository) AuthService {
	return &authService{repo: repo}
}

func (s *authService) Register(ctx context.Context, req entity.CreateUserRequest) (*entity.AuthResponse, error) {
	if req.Name == "" || req.Email == "" || req.Password == "" {
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

	user, err := s.repo.Create(ctx, req.Name, req.Email, req.PhoneNumber, string(hashedPassword))
	if err != nil {
		return nil, err
	}

	accessToken, err := utils.GenerateAccessToken(user.ID)
	if err != nil {
		return nil, err
	}

	refreshToken, err := utils.GenerateRefreshToken(user.ID)
	if err != nil {
		return nil, err
	}

	return &entity.AuthResponse{
		UserID:       user.ID,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
	}, nil
}

func (s *authService) Login(ctx context.Context, req entity.LoginRequest) (*entity.AuthResponse, error) {
	user, err := s.repo.GetByEmail(ctx, req.Email)
	if err != nil {
		slog.Warn("Login failed: user not found", "email", req.Email, "error", err)
		return nil, errors.New("invalid email or password")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password))
	if err != nil {
		slog.Warn("Login failed: password mismatch", "email", req.Email)
		return nil, errors.New("invalid email or password")
	}

	accessToken, err := utils.GenerateAccessToken(user.ID)
	if err != nil {
		return nil, err
	}

	refreshToken, err := utils.GenerateRefreshToken(user.ID)
	if err != nil {
		return nil, err
	}

	return &entity.AuthResponse{
		UserID:       user.ID,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
	}, nil
}

func (s *authService) RefreshToken(ctx context.Context, refreshToken string) (*entity.AuthResponse, error) {
	claims, err := utils.ValidateJWT(refreshToken)
	if err != nil {
		return nil, errors.New("invalid refresh token")
	}

	userID, ok := claims[constants.JWTUserIDClaim].(string)
	if !ok {
		return nil, errors.New("invalid token claims")
	}
	accessToken, err := utils.GenerateAccessToken(userID)
	if err != nil {
		return nil, err
	}

	newRefreshToken, err := utils.GenerateRefreshToken(userID)
	if err != nil {
		return nil, err
	}

	return &entity.AuthResponse{
		UserID:       userID,
		AccessToken:  accessToken,
		RefreshToken: newRefreshToken,
	}, nil
}
