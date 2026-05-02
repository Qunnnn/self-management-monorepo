/// The Self-Management MCP Server.
///
/// Composes all tool mixins and resource support to expose the
/// Self-Management backend API over MCP.
library;

import 'dart:io' as io;

import 'package:dart_mcp/server.dart';
import 'package:stream_channel/stream_channel.dart';

import 'api_client.dart';
import 'tools/auth_tools.dart';
import 'tools/user_tools.dart';
import 'tools/task_tools.dart';
import 'tools/stats_tools.dart';

/// An MCP server that exposes the Self-Management backend REST API.
///
/// Provides:
/// - **Tools**: login, health_check, user CRUD, task CRUD, stats
/// - **Resources**: OpenAPI spec and JSON schemas for AI context
base class SelfManagementMCPServer extends MCPServer
    with ToolsSupport, ResourcesSupport, AuthTools, UserTools, TaskTools, StatsTools {
  SelfManagementMCPServer(StreamChannel<String> channel, {required String baseUrl})
    : apiClient = ApiClient(baseUrl: baseUrl),
      _baseUrl = baseUrl,
      super.fromStreamChannel(
        channel: channel,
        implementation: ServerImplementation(
          name: 'self-management-mcp-server',
          version: '0.1.0',
        ),
        instructions:
            'This MCP server provides tools to interact with the Self-Management '
            'backend API. Use the `login` tool first to authenticate, then call '
            'user/task/stats tools. Use `health_check` to verify the backend is '
            'running.',
      ) {
    // Register all tools.
    registerAuthTools();
    registerUserTools();
    registerTaskTools();
    registerStatsTools();

    // Register resources — OpenAPI spec for AI context.
    _registerResources();
  }

  @override
  final ApiClient apiClient;

  final String _baseUrl;

  void _registerResources() {
    // Expose the OpenAPI spec as a resource so AI assistants have full API context.
    addResource(
      Resource(
        uri: 'self-management://openapi.yaml',
        name: 'Self-Management OpenAPI Spec',
        description: 'The full OpenAPI 3.0 specification for the backend REST API.',
        mimeType: 'application/yaml',
      ),
      (request) {
        try {
          final specFile = io.File('apps/backend/openapi.yaml');
          if (!specFile.existsSync()) {
            // Try relative to the mcp_server directory.
            final altFile = io.File('../backend/openapi.yaml');
            if (altFile.existsSync()) {
              return ReadResourceResult(
                contents: [
                  TextResourceContents(
                    text: altFile.readAsStringSync(),
                    uri: request.uri,
                    mimeType: 'application/yaml',
                  ),
                ],
              );
            }
            return ReadResourceResult(
              contents: [
                TextResourceContents(
                  text: 'OpenAPI spec file not found.',
                  uri: request.uri,
                ),
              ],
            );
          }
          return ReadResourceResult(
            contents: [
              TextResourceContents(
                text: specFile.readAsStringSync(),
                uri: request.uri,
                mimeType: 'application/yaml',
              ),
            ],
          );
        } catch (e) {
          return ReadResourceResult(
            contents: [
              TextResourceContents(
                text: 'Error reading OpenAPI spec: $e',
                uri: request.uri,
              ),
            ],
          );
        }
      },
    );

    // Expose a server info resource.
    addResource(
      Resource(
        uri: 'self-management://info',
        name: 'Server Info',
        description: 'Information about the MCP server and backend connection.',
      ),
      (request) => ReadResourceResult(
        contents: [
          TextResourceContents(
            text: '{'
                '"server": "self-management-mcp-server",'
                '"version": "0.1.0",'
                '"backendUrl": "$_baseUrl",'
                '"authenticated": ${apiClient.isAuthenticated}'
                '}',
            uri: request.uri,
            mimeType: 'application/json',
          ),
        ],
      ),
    );
  }
}
