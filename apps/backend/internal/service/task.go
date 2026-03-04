package service

import (
	"context"

	"self-management-monorepo/apps/backend/internal/entity"
)

// TaskService defines business logic for tasks
type TaskService interface {
	GetTasks(ctx context.Context, completed *bool, limit, offset *int) ([]entity.Task, error)
	GetTaskByID(ctx context.Context, id int) (*entity.Task, error)
	GetTasksByUserID(ctx context.Context, userID int, completed *bool, limit, offset *int) ([]entity.Task, error)
	CreateTask(ctx context.Context, req entity.CreateTaskRequest) (*entity.Task, error)
	CompleteTask(ctx context.Context, id int) (*entity.Task, error)
	DeleteTask(ctx context.Context, id int) error
}

type taskService struct {
	repo TaskRepository
}

func NewTaskService(repo TaskRepository) TaskService {
	return &taskService{repo: repo}
}

func (s *taskService) GetTasks(ctx context.Context, completed *bool, limit, offset *int) ([]entity.Task, error) {
	return s.repo.GetAll(ctx, completed, limit, offset)
}

func (s *taskService) GetTaskByID(ctx context.Context, id int) (*entity.Task, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *taskService) GetTasksByUserID(ctx context.Context, userID int, completed *bool, limit, offset *int) ([]entity.Task, error) {
	return s.repo.GetByUserID(ctx, userID, completed, limit, offset)
}

func (s *taskService) CreateTask(ctx context.Context, req entity.CreateTaskRequest) (*entity.Task, error) {
	if req.Title == "" || req.UserID == 0 {
		return nil, ErrInvalidInput
	}
	return s.repo.Create(ctx, req.UserID, req.Title, req.Description)
}

func (s *taskService) CompleteTask(ctx context.Context, id int) (*entity.Task, error) {
	return s.repo.MarkCompleted(ctx, id)
}

func (s *taskService) DeleteTask(ctx context.Context, id int) error {
	return s.repo.Delete(ctx, id)
}
