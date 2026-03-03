package unit

import (
	"self-management-monorepo/apps/backend/utils"
	"testing"
)

func TestIsValidEmail(t *testing.T) {
	tests := []struct {
		name  string
		email string
		want  bool
	}{
		{"Valid email", "test@example.com", true},
		{"Valid email with dots", "user.name@domain.co.uk", true},
		{"Valid email with plus", "user+label@gmail.com", true},
		{"Missing @", "invalidemail.com", false},
		{"Missing domain", "test@", false},
		{"Double @", "test@@example.com", false},
		{"Missing top-level domain", "test@example", false},
		{"Empty string", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := utils.IsValidEmail(tt.email); got != tt.want {
				t.Errorf("IsValidEmail(%q) = %v, want %v", tt.email, got, tt.want)
			}
		})
	}
}

func TestIsValidPhone(t *testing.T) {
	tests := []struct {
		name  string
		phone string
		want  bool
	}{
		{"Valid simple phone", "0123456789", true},
		{"Valid with hyphen", "012-345-6789", true},
		{"Valid with spaces", "012 345 6789", true},
		{"Valid with plus", "+84123456789", true},
		{"Valid with parentheses", "(012) 345 6789", true},
		{"Empty string (optional)", "", true},
		{"Invalid characters", "01234abc567", false},
		{"Only symbols", "+++---", true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := utils.IsValidPhone(tt.phone); got != tt.want {
				t.Errorf("IsValidPhone(%q) = %v, want %v", tt.phone, got, tt.want)
			}
		})
	}
}
