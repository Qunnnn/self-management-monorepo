package postgres

import (
	"context"
	"database/sql"
	"fmt"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/internal/service"
)

type postgresDiaryRepository struct {
	db *sql.DB
}

// NewDiaryRepository returns a new instance of a PostgreSQL-backed diary repository
func NewDiaryRepository(db *sql.DB) service.DiaryRepository {
	return &postgresDiaryRepository{db: db}
}

func (r *postgresDiaryRepository) GetAll(ctx context.Context, userID string, limit, offset *int) ([]entity.DiaryEntry, error) {
	query := `
		SELECT id, user_id, title, content, mood, latitude, longitude, is_pinned, created_at, updated_at, deleted_at
		FROM diary_entries
		WHERE user_id = $1 AND deleted_at IS NULL
		ORDER BY created_at DESC
	`
	args := []interface{}{userID}

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

	var entries []entity.DiaryEntry
	for rows.Next() {
		var e entity.DiaryEntry
		if err := rows.Scan(
			&e.ID, &e.UserID, &e.Title, &e.Content, &e.Mood, &e.Latitude, &e.Longitude, &e.IsPinned, &e.CreatedAt, &e.UpdatedAt, &e.DeletedAt,
		); err != nil {
			return nil, err
		}
		entries = append(entries, e)
	}
	return entries, nil
}

func (r *postgresDiaryRepository) GetByID(ctx context.Context, id string) (*entity.DiaryEntry, error) {
	var e entity.DiaryEntry
	err := r.db.QueryRowContext(ctx, `
		SELECT id, user_id, title, content, mood, latitude, longitude, is_pinned, created_at, updated_at, deleted_at
		FROM diary_entries
		WHERE id = $1 AND deleted_at IS NULL
	`, id).Scan(
		&e.ID, &e.UserID, &e.Title, &e.Content, &e.Mood, &e.Latitude, &e.Longitude, &e.IsPinned, &e.CreatedAt, &e.UpdatedAt, &e.DeletedAt,
	)

	if err == sql.ErrNoRows {
		return nil, sql.ErrNoRows
	}
	if err != nil {
		return nil, err
	}
	return &e, nil
}

func (r *postgresDiaryRepository) Create(ctx context.Context, req entity.CreateDiaryEntryRequest) (*entity.DiaryEntry, error) {
	var e entity.DiaryEntry
	err := r.db.QueryRowContext(ctx, `
		INSERT INTO diary_entries (user_id, title, content, mood, latitude, longitude, is_pinned)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
		RETURNING id, user_id, title, content, mood, latitude, longitude, is_pinned, created_at, updated_at, deleted_at
	`, req.UserID, req.Title, req.Content, req.Mood, req.Latitude, req.Longitude, req.IsPinned).Scan(
		&e.ID, &e.UserID, &e.Title, &e.Content, &e.Mood, &e.Latitude, &e.Longitude, &e.IsPinned, &e.CreatedAt, &e.UpdatedAt, &e.DeletedAt,
	)

	if err != nil {
		return nil, err
	}
	return &e, nil
}

func (r *postgresDiaryRepository) Update(ctx context.Context, id string, req entity.UpdateDiaryEntryRequest) (*entity.DiaryEntry, error) {
	query := "UPDATE diary_entries SET updated_at = NOW()"
	args := []interface{}{id}
	argIdx := 2

	if req.Title != nil {
		query += fmt.Sprintf(", title = $%d", argIdx)
		args = append(args, *req.Title)
		argIdx++
	}
	if req.Content != nil {
		query += fmt.Sprintf(", content = $%d", argIdx)
		args = append(args, *req.Content)
		argIdx++
	}
	if req.Mood != nil {
		query += fmt.Sprintf(", mood = $%d", argIdx)
		args = append(args, *req.Mood)
		argIdx++
	}
	if req.Latitude != nil {
		query += fmt.Sprintf(", latitude = $%d", argIdx)
		args = append(args, *req.Latitude)
		argIdx++
	}
	if req.Longitude != nil {
		query += fmt.Sprintf(", longitude = $%d", argIdx)
		args = append(args, *req.Longitude)
		argIdx++
	}
	if req.IsPinned != nil {
		query += fmt.Sprintf(", is_pinned = $%d", argIdx)
		args = append(args, *req.IsPinned)
		argIdx++
	}
	query += " WHERE id = $1 AND deleted_at IS NULL RETURNING id, user_id, title, content, mood, latitude, longitude, is_pinned, created_at, updated_at, deleted_at"

	var e entity.DiaryEntry
	err := r.db.QueryRowContext(ctx, query, args...).Scan(
		&e.ID, &e.UserID, &e.Title, &e.Content, &e.Mood, &e.Latitude, &e.Longitude, &e.IsPinned, &e.CreatedAt, &e.UpdatedAt, &e.DeletedAt,
	)

	if err == sql.ErrNoRows {
		return nil, sql.ErrNoRows
	}
	if err != nil {
		return nil, err
	}
	return &e, nil
}

func (r *postgresDiaryRepository) Delete(ctx context.Context, id string) error {
	result, err := r.db.ExecContext(ctx, `
		UPDATE diary_entries SET deleted_at = NOW()
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

func (r *postgresDiaryRepository) AddAttachment(ctx context.Context, entryID string, fileURL string, fileType *string) (*entity.DiaryAttachment, error) {
	var a entity.DiaryAttachment
	err := r.db.QueryRowContext(ctx, `
		INSERT INTO diary_attachments (entry_id, file_url, file_type)
		VALUES ($1, $2, $3)
		RETURNING id, entry_id, file_url, file_type, created_at
	`, entryID, fileURL, fileType).Scan(
		&a.ID, &a.EntryID, &a.FileURL, &a.FileType, &a.CreatedAt,
	)

	if err != nil {
		return nil, err
	}
	return &a, nil
}

func (r *postgresDiaryRepository) GetAttachments(ctx context.Context, entryID string) ([]entity.DiaryAttachment, error) {
	rows, err := r.db.QueryContext(ctx, `
		SELECT id, entry_id, file_url, file_type, created_at
		FROM diary_attachments
		WHERE entry_id = $1
		ORDER BY created_at ASC
	`, entryID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var attachments []entity.DiaryAttachment
	for rows.Next() {
		var a entity.DiaryAttachment
		if err := rows.Scan(&a.ID, &a.EntryID, &a.FileURL, &a.FileType, &a.CreatedAt); err != nil {
			return nil, err
		}
		attachments = append(attachments, a)
	}
	return attachments, nil
}
