.PHONY: backend-run backend-build ios-open

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
