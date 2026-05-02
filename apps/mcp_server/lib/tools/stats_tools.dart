/// MCP tool definitions for statistics.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import '../api_client.dart';

/// Registers statistics-related MCP tools.
base mixin StatsTools on MCPServer, ToolsSupport {
  /// The shared API client — must be provided by the composing server.
  ApiClient get apiClient;

  /// Call this from the server constructor to register the stats tool.
  void registerStatsTools() {
    registerTool(_getStatsTool, _handleGetStats);
  }

  final _getStatsTool = Tool(
    name: 'get_stats',
    description:
        'Get user and task statistics (total users, active tasks). '
        'Requires authentication.',
    inputSchema: Schema.object(properties: {}),
  );

  FutureOr<CallToolResult> _handleGetStats(CallToolRequest request) async {
    try {
      final stats = await apiClient.getStats();
      return CallToolResult(
        content: [
          TextContent(
            text: const JsonEncoder.withIndent('  ').convert(stats),
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to get stats: $e')],
        isError: true,
      );
    }
  }
}
