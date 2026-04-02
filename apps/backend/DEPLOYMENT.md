# Deployment Guide

This application is ready to be deployed to platforms like **Railway**, **Fly.io**, or **Render**.

## Railway Deployment (Recommended)

1. **Push to GitHub**: Make sure your repository is on GitHub.
2. **Create New Project**: On Railway, click "New Project" -> "Deploy from GitHub repo".
3. **Select Repository**: Pick this repository.
4. **Environment Variables**: Add the following variables in the Railway dashboard:
   - `JWT_SECRET`: (Your secret key)
   - `DB_HOST`: `${{postgres.PGHOST}}` (if using Railway Managed Postgres)
   - `DB_PORT`: `${{postgres.PGPORT}}`
   - `DB_USER`: `${{postgres.PGUSER}}`
   - `DB_PASSWORD`: `${{postgres.PGPASSWORD}}`
   - `DB_NAME`: `${{postgres.PGDATABASE}}`
   - `APP_ENV`: `production`
5. **Database**: Add a "PostgreSQL" plugin to your Railway project.

## Local Docker Setup

To run everything locally using Docker:

```bash
cd apps/backend
make docker-up
```

This will:
1. Start a PostgreSQL container.
2. Build and start the Go API container.
3. Automatically run all migrations in the `migrations/` folder.

## Database Migrations

Migrations are automated via `golang-migrate` and run every time the application starts. 

- New migrations should be added to the `migrations/` directory.
- Follow the naming pattern: `00000X_description.up.sql` and `00000X_description.down.sql`.
