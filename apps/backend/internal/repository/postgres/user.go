package postgres

import (
	"context"
	"database/sql"
	"time"

	"self-management-monorepo/apps/backend/internal/entity"
	"self-management-monorepo/apps/backend/internal/service"
)

type postgresUserRepository struct {
	db *sql.DB
}

// NewUserRepository returns a new instance of a PostgreSQL-backed user repository
func NewUserRepository(db *sql.DB) service.UserRepository {
	return &postgresUserRepository{db: db}
}

func (r *postgresUserRepository) GetAll(ctx context.Context) ([]entity.User, error) {
	rows, err := r.db.QueryContext(ctx, "SELECT id, name, email, phone_number, created_at FROM users WHERE deleted_at IS NULL ORDER BY id")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []entity.User
	for rows.Next() {
		var u entity.User
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

func (r *postgresUserRepository) GetByID(ctx context.Context, id string) (*entity.User, error) {
	var u entity.User
	var phone sql.NullString
	err := r.db.QueryRowContext(
		ctx,
		"SELECT id, name, email, phone_number, created_at FROM users WHERE id = $1 AND deleted_at IS NULL",
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

func (r *postgresUserRepository) GetByEmail(ctx context.Context, email string) (*entity.User, error) {
	var u entity.User
	var phone sql.NullString
	err := r.db.QueryRowContext(
		ctx,
		"SELECT id, name, email, phone_number, password, created_at FROM users WHERE email = $1 AND deleted_at IS NULL",
		email,
	).Scan(&u.ID, &u.Name, &u.Email, &phone, &u.Password, &u.CreatedAt)

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

func (r *postgresUserRepository) Create(ctx context.Context, name, email, phone, password string) (*entity.User, error) {
	var u entity.User
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

func (r *postgresUserRepository) Update(ctx context.Context, id string, name, email, phone string) (*entity.User, error) {
	var u entity.User
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

func (r *postgresUserRepository) Delete(ctx context.Context, id string) error {
	result, err := r.db.ExecContext(ctx, "UPDATE users SET deleted_at = CURRENT_TIMESTAMP WHERE id = $1", id)
	if err != nil {
		return err
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		return sql.ErrNoRows
	}
	return nil
}

func (r *postgresUserRepository) GetStats(ctx context.Context) (*entity.UserStats, error) {
	var stats entity.UserStats

	err := r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM users WHERE deleted_at IS NULL").Scan(&stats.TotalUsers)
	if err != nil {
		return nil, err
	}

	err = r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM tasks WHERE is_completed = false AND deleted_at IS NULL").Scan(&stats.ActiveTasks)
	if err != nil {
		return nil, err
	}

	return &stats, nil
}

func (r *postgresUserRepository) SetResetToken(ctx context.Context, email, token string, expiresAt time.Time) error {
	result, err := r.db.ExecContext(ctx, "UPDATE users SET reset_token = $1, reset_token_expires_at = $2 WHERE email = $3 AND deleted_at IS NULL", token, expiresAt, email)
	if err != nil {
		return err
	}
	rows, _ := result.RowsAffected()
	if rows == 0 {
		return sql.ErrNoRows
	}
	return nil
}

func (r *postgresUserRepository) GetUserByResetToken(ctx context.Context, token string) (*entity.User, error) {
	var u entity.User
	err := r.db.QueryRowContext(
		ctx,
		"SELECT id, name, email, reset_token_expires_at FROM users WHERE reset_token = $1 AND deleted_at IS NULL",
		token,
	).Scan(&u.ID, &u.Name, &u.Email, &u.ResetTokenExpiresAt)
	if err == sql.ErrNoRows {
		return nil, sql.ErrNoRows
	}
	if err != nil {
		return nil, err
	}
	return &u, nil
}

func (r *postgresUserRepository) UpdatePasswordAndClearToken(ctx context.Context, id, hashedPassword string) error {
	_, err := r.db.ExecContext(ctx, "UPDATE users SET password = $1, reset_token = NULL, reset_token_expires_at = NULL WHERE id = $2", hashedPassword, id)
	return err
}
