package entity

import "time"

// Mood represents the emotional state associated with a diary entry
type Mood string

const (
	MoodHappy      Mood = "happy"
	MoodProductive Mood = "productive"
	MoodTired      Mood = "tired"
	MoodNeutral    Mood = "neutral"
)

// DiaryEntry represents a diary entry in the database
type DiaryEntry struct {
	ID        string     `json:"id"`
	UserID    string     `json:"userId"`
	Title     string     `json:"title"`
	Content   string     `json:"content"`
	Mood      *Mood      `json:"mood,omitempty"`
	Latitude  *float64   `json:"latitude,omitempty"`
	Longitude *float64   `json:"longitude,omitempty"`
	IsPinned  bool       `json:"isPinned"`
	CreatedAt time.Time  `json:"createdAt"`
	UpdatedAt time.Time  `json:"updatedAt"`
	DeletedAt *time.Time `json:"deletedAt,omitempty"`
}

// DiaryAttachment represents an attachment for a diary entry
type DiaryAttachment struct {
	ID        string    `json:"id"`
	EntryID   string    `json:"entryId"`
	FileURL   string    `json:"fileUrl"`
	FileType  *string   `json:"fileType,omitempty"`
	CreatedAt time.Time `json:"createdAt"`
}

// CreateDiaryEntryRequest is used when creating a new diary entry
type CreateDiaryEntryRequest struct {
	UserID    string   `json:"userId"`
	Title     string   `json:"title"`
	Content   string   `json:"content"`
	Mood      *Mood    `json:"mood,omitempty"`
	Latitude  *float64 `json:"latitude,omitempty"`
	Longitude *float64 `json:"longitude,omitempty"`
	IsPinned  bool     `json:"isPinned"`
}

// UpdateDiaryEntryRequest is used when updating an existing diary entry
type UpdateDiaryEntryRequest struct {
	Title     *string  `json:"title,omitempty"`
	Content   *string  `json:"content,omitempty"`
	Mood      *Mood    `json:"mood,omitempty"`
	Latitude  *float64 `json:"latitude,omitempty"`
	Longitude *float64 `json:"longitude,omitempty"`
	IsPinned  *bool    `json:"isPinned,omitempty"`
}
