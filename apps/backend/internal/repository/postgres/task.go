package postgres

import (
	"context"
	"database/sql"
	"fmt"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/internal/service"
)

type postgresTaskRepository struct {
	db *sql.DB
}

// NewTaskRepository returns a new instance of a PostgreSQL-backed task repository
func NewTaskRepository(db *sql.DB) service.TaskRepository {
	return &postgresTaskRepository{db: db}
}

func (r *postgresTaskRepository) GetAll(ctx context.Context, completed *bool, limit, offset *int) ([]entity.Task, error) {
	query := `
		SELECT id, user_id, title, description, is_completed, created_at, deleted_at
		FROM tasks
		WHERE deleted_at IS NULL
	`
	var args []interface{}

	if completed != nil {
		args = append(args, *completed)
		query += fmt.Sprintf(" AND is_completed = $%d", len(args))
	}

	query += " ORDER BY id"

	if limit != nil {
		args = append(args, *limit)
		query += fmt.Sprintf(" LIMIT $%d", len(args))
	}

	if offset != nil {
		args = append(args, *offset)
		query += fmt.Sprintf(" OFFSET $%d", len(args))
	}

	rows, err := r.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tasks []entity.Task
	for rows.Next() {
		var t entity.Task
		if err := rows.Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt); err != nil {
			return nil, err
		}
		tasks = append(tasks, t)
	}
	return tasks, nil
}

func (r *postgresTaskRepository) GetByID(ctx context.Context, id string) (*entity.Task, error) {
	var t entity.Task
	err := r.db.QueryRowContext(ctx, `
		SELECT id, user_id, title, description, is_completed, created_at, deleted_at
		FROM tasks
		WHERE id = $1 AND deleted_at IS NULL
	`, id).Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt)

	if err == sql.ErrNoRows {
		return nil, sql.ErrNoRows
	}
	if err != nil {
		return nil, err
	}
	return &t, nil
}

func (r *postgresTaskRepository) GetByUserID(ctx context.Context, userID string, completed *bool, limit, offset *int) ([]entity.Task, error) {
	query := `
		SELECT id, user_id, title, description, is_completed, created_at, deleted_at
		FROM tasks
		WHERE user_id = $1 AND deleted_at IS NULL
	`
	args := []interface{}{userID}

	if completed != nil {
		args = append(args, *completed)
		query += fmt.Sprintf(" AND is_completed = $%d", len(args))
	}

	query += " ORDER BY id"

	if limit != nil {
		args = append(args, *limit)
		query += fmt.Sprintf(" LIMIT $%d", len(args))
	}

	if offset != nil {
		args = append(args, *offset)
		query += fmt.Sprintf(" OFFSET $%d", len(args))
	}

	rows, err := r.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tasks []entity.Task
	for rows.Next() {
		var t entity.Task
		if err := rows.Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt); err != nil {
			return nil, err
		}
		tasks = append(tasks, t)
	}
	return tasks, nil
}

func (r *postgresTaskRepository) Create(ctx context.Context, userID string, title string, description *string) (*entity.Task, error) {
	var t entity.Task
	err := r.db.QueryRowContext(ctx, `
		INSERT INTO tasks (user_id, title, description)
		VALUES ($1, $2, $3)
		RETURNING id, user_id, title, description, is_completed, created_at, deleted_at
	`, userID, title, description).Scan(
		&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt,
	)

	if err != nil {
		return nil, err
	}
	return &t, nil
}

func (r *postgresTaskRepository) MarkCompleted(ctx context.Context, id string) (*entity.Task, error) {
	var t entity.Task
	err := r.db.QueryRowContext(ctx, `
		UPDATE tasks SET is_completed = true
		WHERE id = $1 AND deleted_at IS NULL
		RETURNING id, user_id, title, description, is_completed, created_at, deleted_at
	`, id).Scan(&t.ID, &t.UserID, &t.Title, &t.Description, &t.IsCompleted, &t.CreatedAt, &t.DeletedAt)

	if err == sql.ErrNoRows {
		return nil, sql.ErrNoRows
	}
	if err != nil {
		return nil, err
	}
	return &t, nil
}

func (r *postgresTaskRepository) Delete(ctx context.Context, id string) error {
	result, err := r.db.ExecContext(ctx, `
		UPDATE tasks SET deleted_at = NOW()
		WHERE id = $1 AND deleted_at IS NULL
	`, id)
	if err != nil {
		return err
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		return sql.ErrNoRows
	}
	return nil
}
