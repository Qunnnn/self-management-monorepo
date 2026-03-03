package service

import (
	"context"
	"self-management-monorepo/apps/backend/models"
	"self-management-monorepo/apps/backend/repository"
)

// TaskService defines business logic for tasks
type TaskService interface {
	GetTasks(ctx context.Context, completed *bool, limit, offset *int) ([]models.Task, error)
	GetTaskByID(ctx context.Context, id int) (*models.Task, error)
	GetTasksByUserID(ctx context.Context, userID int, completed *bool, limit, offset *int) ([]models.Task, error)
	CreateTask(ctx context.Context, req models.CreateTaskRequest) (*models.Task, error)
	CompleteTask(ctx context.Context, id int) (*models.Task, error)
	DeleteTask(ctx context.Context, id int) error
}

type taskService struct {
	repo repository.TaskRepository
}

func NewTaskService(repo repository.TaskRepository) TaskService {
	return &taskService{repo: repo}
}

func (s *taskService) GetTasks(ctx context.Context, completed *bool, limit, offset *int) ([]models.Task, error) {
	return s.repo.GetAll(ctx, completed, limit, offset)
}

func (s *taskService) GetTaskByID(ctx context.Context, id int) (*models.Task, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *taskService) GetTasksByUserID(ctx context.Context, userID int, completed *bool, limit, offset *int) ([]models.Task, error) {
	return s.repo.GetByUserID(ctx, userID, completed, limit, offset)
}

func (s *taskService) CreateTask(ctx context.Context, req models.CreateTaskRequest) (*models.Task, error) {
	if req.Title == "" || req.UserID == 0 {
		return nil, ErrInvalidInput
	}
	return s.repo.Create(ctx, req.UserID, req.Title, req.Description)
}

func (s *taskService) CompleteTask(ctx context.Context, id int) (*models.Task, error) {
	return s.repo.MarkCompleted(ctx, id)
}

func (s *taskService) DeleteTask(ctx context.Context, id int) error {
	return s.repo.Delete(ctx, id)
}
