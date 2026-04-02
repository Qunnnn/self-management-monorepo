.PHONY: run build test clean docker-up docker-down migrate-up migrate-down seed-db nuke-redeploy

run:
	go run cmd/main.go

build:
	go build -ldflags="-s -w" -o pg-api cmd/main.go

clean:
	rm -f pg-api main

test:
	go test ./...

docker-up:
	docker-compose up --build -d

docker-down:
	docker-compose down

# Helper for manual migrations if needed (requires golang-migrate CLI)
migrate-up:
	migrate -path migrations -database "postgres://$(DB_USER):$(DB_PASSWORD)@localhost:5432/$(DB_NAME)?sslmode=disable" up

migrate-down:
	migrate -path migrations -database "postgres://$(DB_USER):$(DB_PASSWORD)@localhost:5432/$(DB_NAME)?sslmode=disable" down

# Seed the database (requires psql installed locally or runs via docker)
seed-db:
	@echo "Seeding database..."
	cat seed/01_users.sql | docker exec -i $$(docker-compose ps -q db) psql -U $(DB_USER) -d $(DB_NAME)
	cat seed/02_tasks.sql | docker exec -i $$(docker-compose ps -q db) psql -U $(DB_USER) -d $(DB_NAME)
	cat seed/03_diary.sql | docker exec -i $$(docker-compose ps -q db) psql -U $(DB_USER) -d $(DB_NAME)
	@echo "Seeding completed successfully!"

# Full reset: stops everything, wipes data, rebuilds, and seeds
nuke-redeploy:
	@echo "Nuking existing environment..."
	docker-compose down -v
	@echo "Starting fresh Docker containers..."
	docker-compose up --build -d
	@echo "Waiting for database to be ready (5s)..."
	@sleep 5
	@$(MAKE) seed-db
	@echo "==================================="
	@echo "Nuke & Redeploy completed!"
	@echo "Local Server: http://localhost:8080"
	@echo "==================================="
