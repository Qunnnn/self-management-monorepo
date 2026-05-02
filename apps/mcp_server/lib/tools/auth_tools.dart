/// MCP tool definitions for authentication.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import '../api_client.dart';

/// Registers authentication-related MCP tools.
base mixin AuthTools on MCPServer, ToolsSupport {
  /// The shared API client — must be provided by the composing server.
  ApiClient get apiClient;

  /// Call this from the server constructor to register all auth tools.
  void registerAuthTools() {
    registerTool(_loginTool, _handleLogin);
    registerTool(_healthCheckTool, _handleHealthCheck);
  }

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  final _loginTool = Tool(
    name: 'login',
    description:
        'Authenticate with the Self-Management backend. '
        'Returns a JWT token that is stored for subsequent API calls.',
    inputSchema: Schema.object(
      properties: {
        'email': Schema.string(description: 'User email address'),
        'password': Schema.string(description: 'User password'),
      },
      required: ['email', 'password'],
    ),
  );

  FutureOr<CallToolResult> _handleLogin(CallToolRequest request) async {
    try {
      final args = request.arguments!;
      final result = await apiClient.login(
        email: args['email'] as String,
        password: args['password'] as String,
      );
      return CallToolResult(
        content: [
          TextContent(
            text: 'Login successful. Token stored for subsequent calls.\n'
                '${const JsonEncoder.withIndent('  ').convert(result)}',
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Login failed: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Health Check
  // ---------------------------------------------------------------------------

  final _healthCheckTool = Tool(
    name: 'health_check',
    description: 'Check if the Self-Management backend server is running.',
    inputSchema: Schema.object(properties: {}),
  );

  FutureOr<CallToolResult> _handleHealthCheck(CallToolRequest request) async {
    try {
      final result = await apiClient.healthCheck();
      return CallToolResult(content: [TextContent(text: 'Backend: $result')]);
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Backend unreachable: $e')],
        isError: true,
      );
    }
  }
}
