package constants

type ContextKey string

const (
	UserIDKey ContextKey = "user_id"

	// JWT claims
	JWTUserIDClaim = "user_id"
)
