# Self-Management MCP Server

A custom [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) server built with [`dart_mcp`](https://pub.dev/packages/dart_mcp) that exposes the Self-Management backend REST API as MCP tools and resources.

## What does this do?

This allows AI assistants (Gemini, Copilot, Claude, etc.) to interact with your Self-Management backend directly — creating tasks, managing users, checking stats — all through MCP tool calls.

## Setup

```bash
cd apps/mcp_server
dart pub get
```

## Usage

### As a standalone server (stdio)

```bash
dart run bin/server.dart
```

### With Docker

From the **root of the monorepo**, build the Docker image:

```bash
docker build -t self-management-mcp-server -f apps/mcp_server/Dockerfile .
```

You can then run it locally (interactive mode to keep stdio open):

```bash
docker run -i --rm -e API_BASE_URL=http://host.docker.internal:8080 self-management-mcp-server
```

*(Note: `host.docker.internal` is used to reach the backend running on your Mac's localhost)*

### With a custom backend URL

```bash
API_BASE_URL=http://my-server:8080 dart run bin/server.dart
```

### MCP Configuration (`.mcp.json`)

The server is already registered in the project's `.mcp.json`:

```json
{
  "self-management": {
    "type": "stdio",
    "command": "dart",
    "args": ["run", "apps/mcp_server/bin/server.dart"],
    "env": {
      "API_BASE_URL": "http://localhost:8080"
    }
  }
}
```

## Available Tools

| Tool | Description | Auth Required |
|------|-------------|:---:|
| `health_check` | Check if backend is running | ❌ |
| `login` | Authenticate and store JWT token | ❌ |
| `list_users` | List all users | ✅ |
| `get_user` | Get user by ID | ✅ |
| `create_user` | Create a new user | ❌ |
| `update_user` | Update user details | ✅ |
| `delete_user` | Delete a user | ✅ |
| `list_tasks` | List all tasks | ✅ |
| `list_user_tasks` | List tasks for a user | ✅ |
| `get_task` | Get task by ID | ✅ |
| `create_task` | Create a new task | ✅ |
| `complete_task` | Mark task as completed | ✅ |
| `delete_task` | Delete a task | ✅ |
| `get_stats` | Get user/task statistics | ✅ |

## Available Resources

| URI | Description |
|-----|-------------|
| `self-management://openapi.yaml` | Full OpenAPI 3.0 specification |
| `self-management://info` | Server info and connection status |

## Architecture

```
bin/server.dart          ← Entry point (stdio transport)
lib/
  server.dart            ← MCPServer composing all mixins
  api_client.dart        ← Dio HTTP client wrapping backend API
  tools/
    auth_tools.dart      ← login, health_check
    user_tools.dart      ← user CRUD tools
    task_tools.dart       ← task CRUD + complete tools
    stats_tools.dart     ← stats tool
```
