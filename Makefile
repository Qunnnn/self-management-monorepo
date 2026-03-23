.PHONY: backend-run backend-build ios-open ios-sync

# Backend
backend-run:
	cd apps/backend && go run .

backend-build:
	cd apps/backend && go build -o pg-api .

backend-test:
	cd apps/backend && go test ./...

# iOS
ios-open:
	open apps/ios/self-management.xcodeproj

ios-sync:
	cd apps/ios && ruby add_file.rb
