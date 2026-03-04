package utils

import (
	"regexp"
)

// Regex patterns for validation
var (
	emailRegex = regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)
	phoneRegex = regexp.MustCompile(`^[0-9\-\+\s\(\)]+$`)
)

// IsValidEmail checks if the provided email string has a valid format
func IsValidEmail(email string) bool {
	return emailRegex.MatchString(email)
}

// IsValidPhone checks if the provided phone string has a valid format
func IsValidPhone(phone string) bool {
	if phone == "" {
		// Empty is valid because phone number is optional
		return true
	}
	return phoneRegex.MatchString(phone)
}

// ToNullString converts a regular string to an interface{}, returning nil if empty.
// This is useful for inserting NULLs into PostgreSQL instead of empty strings.
func ToNullString(s string) interface{} {
	if s == "" {
		return nil
	}
	return s
}
