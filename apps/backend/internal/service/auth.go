package service

import (
	"context"
	"crypto/rand"
	"database/sql"
	"encoding/hex"
	"errors"
	"log/slog"
	"time"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/pkg/constants"
	"self-management-monorepo/apps/backend/pkg/utils"

	"golang.org/x/crypto/bcrypt"
)

type AuthService interface {
	Register(ctx context.Context, req entity.CreateUserRequest) (*entity.AuthResponse, error)
	Login(ctx context.Context, req entity.LoginRequest) (*entity.AuthResponse, error)
	RefreshToken(ctx context.Context, refreshToken string) (*entity.AuthResponse, error)
	ForgotPassword(ctx context.Context, req entity.ForgotPasswordRequest) error
	ResetPassword(ctx context.Context, req entity.ResetPasswordRequest) error
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

func (s *authService) ForgotPassword(ctx context.Context, req entity.ForgotPasswordRequest) error {
	if req.Email == "" {
		return ErrInvalidInput
	}
	
	// Generate random token
	tokenBytes := make([]byte, 32)
	rand.Read(tokenBytes)
	token := hex.EncodeToString(tokenBytes)
	
	expiresAt := time.Now().Add(15 * time.Minute)
	
	err := s.repo.SetResetToken(ctx, req.Email, token, expiresAt)
	if err == sql.ErrNoRows {
		// Don't leak that email doesn't exist
		return nil
	}
	if err != nil {
		return err
	}
	
	// TODO: Send email
	slog.Info("Password reset token generated", "email", req.Email, "token", token)
	
	return nil
}

func (s *authService) ResetPassword(ctx context.Context, req entity.ResetPasswordRequest) error {
	if req.Token == "" || req.NewPassword == "" {
		return ErrInvalidInput
	}
	
	user, err := s.repo.GetUserByResetToken(ctx, req.Token)
	if err != nil {
		return errors.New("invalid or expired token")
	}
	
	if user.ResetTokenExpiresAt == nil || user.ResetTokenExpiresAt.Before(time.Now()) {
		return errors.New("invalid or expired token")
	}
	
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	
	return s.repo.UpdatePasswordAndClearToken(ctx, user.ID, string(hashedPassword))
}
