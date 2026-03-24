-- Add tasks for that user (using subquery to get the UUID)
INSERT INTO tasks (user_id, title, description, is_completed)
VALUES 
((SELECT id FROM users WHERE email = 'demo@example.com'), 'Complete project setup', 'Initialize monorepo and backend services', true),
((SELECT id FROM users WHERE email = 'demo@example.com'), 'Fix database connection', 'Ensure backend connects to PostgreSQL via Unix socket', true),
((SELECT id FROM users WHERE email = 'demo@example.com'), 'Implement auth', 'Add user login and registration flow', false),
((SELECT id FROM users WHERE email = 'demo@example.com'), 'Deploy to production', 'Finalize infrastructure and CI/CD', false);
