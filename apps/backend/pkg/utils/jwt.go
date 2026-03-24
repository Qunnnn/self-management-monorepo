package utils

import (
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"

	"self-management-monorepo/apps/backend/pkg/constants"
)

func getSecret() []byte {
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		return []byte("fallback_secret_for_local_dev")
	}
	return []byte(secret)
}

// GenerateAccessToken creates a new token valid for 24 hours
func GenerateAccessToken(userID string) (string, error) {
	claims := jwt.MapClaims{
		constants.JWTUserIDClaim: userID,
		"exp":                    time.Now().Add(time.Hour * 24).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(getSecret())
}

// GenerateRefreshToken creates a new token valid for 7 days
func GenerateRefreshToken(userID string) (string, error) {
	claims := jwt.MapClaims{
		constants.JWTUserIDClaim: userID,
		"exp":                    time.Now().Add(time.Hour * 24 * 7).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(getSecret())
}

// ValidateJWT parses and validates a token, returning the underlying claims if valid
func ValidateJWT(tokenString string) (jwt.MapClaims, error) {
	token, err := jwt.Parse(tokenString, func(t *jwt.Token) (any, error) {
		// Validating the signing method
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("unexpected signing method")
		}
		return getSecret(), nil
	})

	if err != nil {
		return nil, err
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return nil, errors.New("invalid token format")
	}

	return claims, nil
}
