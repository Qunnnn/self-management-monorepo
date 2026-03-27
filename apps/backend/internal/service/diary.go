package service

import (
	"context"

	"self-management-monorepo/apps/backend/internal/entity"
)

// DiaryService defines business logic for diary entries
type DiaryService interface {
	GetDiaryEntries(ctx context.Context, userID string, limit, offset *int) ([]entity.DiaryEntry, error)
	GetDiaryEntry(ctx context.Context, id string) (*entity.DiaryEntry, error)
	CreateDiaryEntry(ctx context.Context, req entity.CreateDiaryEntryRequest) (*entity.DiaryEntry, error)
	UpdateDiaryEntry(ctx context.Context, id string, req entity.UpdateDiaryEntryRequest) (*entity.DiaryEntry, error)
	DeleteDiaryEntry(ctx context.Context, id string) error
	
	// Attachments
	AddAttachment(ctx context.Context, entryID string, fileURL string, fileType *string) (*entity.DiaryAttachment, error)
	GetAttachments(ctx context.Context, entryID string) ([]entity.DiaryAttachment, error)
}

type diaryService struct {
	repo DiaryRepository
}

// NewDiaryService returns a new instance of a diary service
func NewDiaryService(repo DiaryRepository) DiaryService {
	return &diaryService{repo: repo}
}

func (s *diaryService) GetDiaryEntries(ctx context.Context, userID string, limit, offset *int) ([]entity.DiaryEntry, error) {
	return s.repo.GetAll(ctx, userID, limit, offset)
}

func (s *diaryService) GetDiaryEntry(ctx context.Context, id string) (*entity.DiaryEntry, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *diaryService) CreateDiaryEntry(ctx context.Context, req entity.CreateDiaryEntryRequest) (*entity.DiaryEntry, error) {
	if req.UserID == "" || req.Content == "" {
		return nil, ErrInvalidInput
	}
	return s.repo.Create(ctx, req)
}

func (s *diaryService) UpdateDiaryEntry(ctx context.Context, id string, req entity.UpdateDiaryEntryRequest) (*entity.DiaryEntry, error) {
	return s.repo.Update(ctx, id, req)
}

func (s *diaryService) DeleteDiaryEntry(ctx context.Context, id string) error {
	return s.repo.Delete(ctx, id)
}

func (s *diaryService) AddAttachment(ctx context.Context, entryID string, fileURL string, fileType *string) (*entity.DiaryAttachment, error) {
	if entryID == "" || fileURL == "" {
		return nil, ErrInvalidInput
	}
	return s.repo.AddAttachment(ctx, entryID, fileURL, fileType)
}

func (s *diaryService) GetAttachments(ctx context.Context, entryID string) ([]entity.DiaryAttachment, error) {
	return s.repo.GetAttachments(ctx, entryID)
}
