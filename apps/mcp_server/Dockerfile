# Use the official Dart image for the build stage
FROM dart:stable AS build

WORKDIR /app

# Copy the mcp_server pubspec and get dependencies
COPY apps/mcp_server/pubspec.* apps/mcp_server/
WORKDIR /app/apps/mcp_server
RUN dart pub get

# Copy the source code
COPY apps/mcp_server/ .
RUN dart compile exe bin/server.dart -o bin/server

# Build a minimal runtime image
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/apps/mcp_server/bin/server /server

# Copy the OpenAPI spec so the server can expose it as an MCP resource
COPY apps/backend/openapi.yaml /apps/backend/openapi.yaml

# Set working directory to root so the file path `apps/backend/openapi.yaml` works
WORKDIR /

# Start the server via stdio
ENTRYPOINT ["/server"]
