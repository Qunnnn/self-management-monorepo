package middleware

import (
	"context"
	"net/http"
	"strings"

	"self-management-monorepo/apps/backend/pkg/constants"
	"self-management-monorepo/apps/backend/pkg/utils"
)

// AuthMiddleware intercepts requests to ensure a valid JWT is present
func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			utils.WriteError(w, "missing authorization header", http.StatusUnauthorized, nil)
			return
		}

		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			utils.WriteError(w, "invalid authorization header format", http.StatusUnauthorized, nil)
			return
		}

		tokenStr := parts[1]
		claims, err := utils.ValidateJWT(tokenStr)
		if err != nil {
			msg := "token is invalid"
			if strings.Contains(err.Error(), "expired") {
				msg = "token has expired"
			}
			utils.WriteError(w, msg, http.StatusUnauthorized, err)
			return
		}

		userIDFloat, ok := claims[constants.JWTUserIDClaim].(float64)
		if !ok {
			utils.WriteError(w, "invalid token claims", http.StatusUnauthorized, nil)
			return
		}

		ctx := context.WithValue(r.Context(), constants.UserIDKey, int(userIDFloat))
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
