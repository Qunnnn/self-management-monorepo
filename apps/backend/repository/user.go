package repository

import (
	"context"
	"database/sql"

	"self-management-monorepo/apps/backend/models"
)

// UserRepository defines the operations for user data access
type UserRepository interface {
	GetAll(ctx context.Context) ([]models.User, error)
	GetByID(ctx context.Context, id int) (*models.User, error)
	Create(ctx context.Context, name, email, phone, password string) (*models.User, error)
	Update(ctx context.Context, id int, name, email, phone string) (*models.User, error)
	Delete(ctx context.Context, id int) error
	GetStats(ctx context.Context) (*models.UserStats, error)
}

type postgresUserRepository struct {
	db *sql.DB
}

// NewUserRepository returns a new instance of a PostgreSQL-backed user repository
func NewUserRepository(db *sql.DB) UserRepository {
	return &postgresUserRepository{db: db}
}

func (r *postgresUserRepository) GetAll(ctx context.Context) ([]models.User, error) {
	rows, err := r.db.QueryContext(ctx, "SELECT id, name, email, phone_number, created_at FROM users ORDER BY id")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []models.User
	for rows.Next() {
		var u models.User
		var phone sql.NullString
		if err := rows.Scan(&u.ID, &u.Name, &u.Email, &phone, &u.CreatedAt); err != nil {
			return nil, err
		}
		if phone.Valid {
			u.PhoneNumber = phone.String
		}
		users = append(users, u)
	}
	return users, nil
}

func (r *postgresUserRepository) GetByID(ctx context.Context, id int) (*models.User, error) {
	var u models.User
	var phone sql.NullString
	err := r.db.QueryRowContext(
		ctx,
		"SELECT id, name, email, phone_number, created_at FROM users WHERE id = $1",
		id,
	).Scan(&u.ID, &u.Name, &u.Email, &phone, &u.CreatedAt)

	if err == sql.ErrNoRows {
		return nil, sql.ErrNoRows
	}
	if err != nil {
		return nil, err
	}

	if phone.Valid {
		u.PhoneNumber = phone.String
	}
	return &u, nil
}

func (r *postgresUserRepository) Create(ctx context.Context, name, email, phone, password string) (*models.User, error) {
	var u models.User
	var resPhone sql.NullString

	// Convert empty string to nil for SQL NULL
	var sqlPhone interface{}
	if phone != "" {
		sqlPhone = phone
	}

	err := r.db.QueryRowContext(
		ctx,
		"INSERT INTO users (name, email, phone_number, password) VALUES ($1, $2, $3, $4) RETURNING id, name, email, phone_number, created_at",
		name, email, sqlPhone, password,
	).Scan(&u.ID, &u.Name, &u.Email, &resPhone, &u.CreatedAt)

	if err != nil {
		return nil, err
	}

	if resPhone.Valid {
		u.PhoneNumber = resPhone.String
	}
	return &u, nil
}

func (r *postgresUserRepository) Update(ctx context.Context, id int, name, email, phone string) (*models.User, error) {
	var u models.User
	var resPhone sql.NullString

	var sqlPhone interface{}
	if phone != "" {
		sqlPhone = phone
	}

	err := r.db.QueryRowContext(
		ctx,
		"UPDATE users SET name = $1, email = $2, phone_number = $3 WHERE id = $4 RETURNING id, name, email, phone_number, created_at",
		name, email, sqlPhone, id,
	).Scan(&u.ID, &u.Name, &u.Email, &resPhone, &u.CreatedAt)

	if err == sql.ErrNoRows {
		return nil, sql.ErrNoRows
	}
	if err != nil {
		return nil, err
	}

	if resPhone.Valid {
		u.PhoneNumber = resPhone.String
	}
	return &u, nil
}

func (r *postgresUserRepository) Delete(ctx context.Context, id int) error {
	result, err := r.db.ExecContext(ctx, "DELETE FROM users WHERE id = $1", id)
	if err != nil {
		return err
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		return sql.ErrNoRows
	}
	return nil
}

func (r *postgresUserRepository) GetStats(ctx context.Context) (*models.UserStats, error) {
	var stats models.UserStats

	err := r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM users").Scan(&stats.TotalUsers)
	if err != nil {
		return nil, err
	}

	err = r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM tasks WHERE is_completed = false AND deleted_at IS NULL").Scan(&stats.ActiveTasks)
	if err != nil {
		return nil, err
	}

	return &stats, nil
}
