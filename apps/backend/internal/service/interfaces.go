package service

import (
	"context"
	"time"

	"self-management-monorepo/apps/backend/internal/entity"
)

// UserRepository defines the operations for user data access
type UserRepository interface {
	GetAll(ctx context.Context) ([]entity.User, error)
	GetByID(ctx context.Context, id string) (*entity.User, error)
	GetByEmail(ctx context.Context, email string) (*entity.User, error)
	Create(ctx context.Context, name, email, phone, password string) (*entity.User, error)
	Update(ctx context.Context, id string, name, email, phone string) (*entity.User, error)
	Delete(ctx context.Context, id string) error
	GetStats(ctx context.Context) (*entity.UserStats, error)
	SetResetToken(ctx context.Context, email, token string, expiresAt time.Time) error
	GetUserByResetToken(ctx context.Context, token string) (*entity.User, error)
	UpdatePasswordAndClearToken(ctx context.Context, id, hashedPassword string) error
}

// TaskRepository defines the operations for task data access
type TaskRepository interface {
	GetAll(ctx context.Context, completed *bool, limit, offset *int) ([]entity.Task, error)
	GetByID(ctx context.Context, id string) (*entity.Task, error)
	GetByUserID(ctx context.Context, userID string, completed *bool, limit, offset *int) ([]entity.Task, error)
	Create(ctx context.Context, userID string, title string, description *string) (*entity.Task, error)
	MarkCompleted(ctx context.Context, id string) (*entity.Task, error)
	Delete(ctx context.Context, id string) error
}

// DiaryRepository defines the operations for diary data access
type DiaryRepository interface {
	GetAll(ctx context.Context, userID string, limit, offset *int) ([]entity.DiaryEntry, error)
	GetByID(ctx context.Context, id string) (*entity.DiaryEntry, error)
	Create(ctx context.Context, req entity.CreateDiaryEntryRequest) (*entity.DiaryEntry, error)
	Update(ctx context.Context, id string, req entity.UpdateDiaryEntryRequest) (*entity.DiaryEntry, error)
	Delete(ctx context.Context, id string) error

	// Attachments
	AddAttachment(ctx context.Context, entryID string, fileURL string, fileType *string) (*entity.DiaryAttachment, error)
	GetAttachments(ctx context.Context, entryID string) ([]entity.DiaryAttachment, error)
}
