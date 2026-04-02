-- Core Diary Entry
CREATE TABLE IF NOT EXISTS diary_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    mood VARCHAR(30),           -- e.g., "productive", "tired", "happy"
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    is_pinned BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Media Metadata
CREATE TABLE IF NOT EXISTS diary_attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entry_id UUID REFERENCES diary_entries(id) ON DELETE CASCADE,
    file_url TEXT NOT NULL,     -- S3/Cloud Storage link
    file_type VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexing for performant history fetches
CREATE INDEX IF NOT EXISTS idx_diary_user_date ON diary_entries(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_diary_active ON diary_entries(deleted_at) WHERE deleted_at IS NULL;
