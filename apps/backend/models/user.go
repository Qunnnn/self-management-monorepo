package models

import "time"

// User represents a user in the database
type User struct {
	ID          int       `json:"id"`
	Name        string    `json:"name"`
	Email       string    `json:"email"`
	CreatedAt   time.Time `json:"createdAt"`
	PhoneNumber string    `json:"phoneNumber,omitempty"`
	Password    string    `json:"-"`
}

// CreateUserRequest is used when creating a new user
type CreateUserRequest struct {
	Name        string `json:"name"`
	Email       string `json:"email"`
	PhoneNumber string `json:"phoneNumber,omitempty"`
	Password    string `json:"password"`
}

// ModifyUserRequest is used when updating an existing user
type ModifyUserRequest struct {
	Name        string `json:"name,omitempty"`
	Email       string `json:"email,omitempty"`
	PhoneNumber string `json:"phoneNumber,omitempty"`
}
