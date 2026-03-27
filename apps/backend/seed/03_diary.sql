-- Seed diary entries for demo user
DO $$
DECLARE
    v_user_id UUID;
    v_entry_1 UUID;
    v_entry_2 UUID;
BEGIN
    SELECT id INTO v_user_id FROM users WHERE email = 'demo@example.com' LIMIT 1;
    
    IF v_user_id IS NOT NULL THEN
        -- Entry 1: The First Step
        INSERT INTO diary_entries (user_id, title, content, mood, is_pinned)
        VALUES (v_user_id, 'My First Self-Management Entry', 'Today I started using this new system. I feel organized and ready to tackle my goals.', 'productive', true)
        RETURNING id INTO v_entry_1;

        -- Entry 2: Learning Progress
        INSERT INTO diary_entries (user_id, title, content, mood, latitude, longitude)
        VALUES (v_user_id, 'Afternoon Coffee Thoughts', 'I am currently sitting in a cafe, thinking about how much I have achieved this week. Clean architecture is tricky but satisfying.', 'happy', 13.7563, 100.5018)
        RETURNING id INTO v_entry_2;

        -- Attachments for Entry 2
        INSERT INTO diary_attachments (entry_id, file_url, file_type)
        VALUES (v_entry_2, 'https://images.unsplash.com/photo-1541167760496-162955ed8a9f', 'image/jpeg');
    END IF;
END $$;
