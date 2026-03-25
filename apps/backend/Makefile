.PHONY: run build test clean

run:
	go run cmd/main.go

build:
	go build -ldflags="-s -w" -o pg-api cmd/main.go

clean:
	rm -f pg-api main

test:
	go test ./...
