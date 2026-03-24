.PHONY: backend-run backend-build ios-open ios-sync db-start db-stop db-status db-migrate db-seed db-reset db-console

# Database
db-start:
	brew services start postgresql@14

db-stop:
	brew services stop postgresql@14

db-status:
	brew services info postgresql@14

db-migrate:
	@echo "Applying all pending migrations..."
	@for f in $$(ls apps/backend/migrations/*.up.sql | sort); do \
		echo "Applying $$f..."; \
		psql -U qun -d pg_learning -f $$f; \
	done

db-seed:
	@echo "Seeding database..."
	@for f in $$(ls apps/backend/seed/*.sql | sort); do \
		echo "Seeding $$f..."; \
		psql -U qun -d pg_learning -f $$f; \
	done

db-reset:
	@echo "Nuking and rebuilding database..."
	@psql -U qun -d pg_learning -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
	@$(MAKE) db-migrate
	@$(MAKE) db-seed

db-console:
	psql -U qun -d pg_learning

# Backend
backend-run:
	cd apps/backend && go run cmd/main.go

backend-build:
	cd apps/backend && go build -o pg-api cmd/main.go

backend-test:
	cd apps/backend && go test ./...

# iOS
ios-open:
	open apps/ios/self-management.xcodeproj

ios-sync:
	cd apps/ios && ruby add_file.rb
