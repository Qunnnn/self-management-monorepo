package entity

import "time"

// Task represents a task in the database
type Task struct {
	ID          string     `json:"id"`
	UserID      string     `json:"userId"`
	Title       string     `json:"title"`
	Description *string    `json:"description,omitempty"`
	IsCompleted bool       `json:"isCompleted"`
	CreatedAt   time.Time  `json:"createdAt"`
	DeletedAt   *time.Time `json:"deletedAt,omitempty"`
}

// CreateTaskRequest is used when creating a new task
type CreateTaskRequest struct {
	UserID      string  `json:"userId"`
	Title       string  `json:"title"`
	Description *string `json:"description,omitempty"`
}
