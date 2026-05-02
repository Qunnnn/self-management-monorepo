/// MCP tool definitions for user management.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import '../api_client.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// Registers user-related MCP tools (list, get, create, update, delete).
base mixin UserTools on MCPServer, ToolsSupport {
  /// The shared API client — must be provided by the composing server.
  ApiClient get apiClient;

  /// Call this from the server constructor to register all user tools.
  void registerUserTools() {
    registerTool(_listUsersTool, _handleListUsers);
    registerTool(_getUserTool, _handleGetUser);
    registerTool(_createUserTool, _handleCreateUser);
    registerTool(_updateUserTool, _handleUpdateUser);
    registerTool(_deleteUserTool, _handleDeleteUser);
  }

  // ---------------------------------------------------------------------------
  // List Users
  // ---------------------------------------------------------------------------

  final _listUsersTool = Tool(
    name: 'list_users',
    description: 'List all users in the system. Requires authentication.',
    inputSchema: Schema.object(properties: {}),
  );

  FutureOr<CallToolResult> _handleListUsers(CallToolRequest request) async {
    try {
      final users = await apiClient.listUsers();
      return CallToolResult(
        content: [TextContent(text: _encoder.convert(users))],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to list users: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Get User
  // ---------------------------------------------------------------------------

  final _getUserTool = Tool(
    name: 'get_user',
    description: 'Get a specific user by their ID. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'id': Schema.int(description: 'The user ID'),
      },
      required: ['id'],
    ),
  );

  FutureOr<CallToolResult> _handleGetUser(CallToolRequest request) async {
    try {
      final id = request.arguments!['id'] as int;
      final user = await apiClient.getUser(id);
      return CallToolResult(
        content: [TextContent(text: _encoder.convert(user))],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to get user: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Create User
  // ---------------------------------------------------------------------------

  final _createUserTool = Tool(
    name: 'create_user',
    description: 'Create a new user. Does NOT require authentication.',
    inputSchema: Schema.object(
      properties: {
        'name': Schema.string(description: 'Full name of the user'),
        'email': Schema.string(description: 'Email address'),
        'password': Schema.string(description: 'Password for the account'),
        'phoneNumber': Schema.string(
          description: 'Optional phone number',
        ),
      },
      required: ['name', 'email', 'password'],
    ),
  );

  FutureOr<CallToolResult> _handleCreateUser(CallToolRequest request) async {
    try {
      final args = request.arguments!;
      final user = await apiClient.createUser(
        name: args['name'] as String,
        email: args['email'] as String,
        password: args['password'] as String,
        phoneNumber: args['phoneNumber'] as String?,
      );
      return CallToolResult(
        content: [TextContent(text: 'User created:\n${_encoder.convert(user)}')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to create user: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Update User
  // ---------------------------------------------------------------------------

  final _updateUserTool = Tool(
    name: 'update_user',
    description: 'Update an existing user. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'id': Schema.int(description: 'The user ID to update'),
        'name': Schema.string(description: 'New name (optional)'),
        'email': Schema.string(description: 'New email (optional)'),
        'phoneNumber': Schema.string(description: 'New phone number (optional)'),
      },
      required: ['id'],
    ),
  );

  FutureOr<CallToolResult> _handleUpdateUser(CallToolRequest request) async {
    try {
      final args = request.arguments!;
      final user = await apiClient.updateUser(
        args['id'] as int,
        name: args['name'] as String?,
        email: args['email'] as String?,
        phoneNumber: args['phoneNumber'] as String?,
      );
      return CallToolResult(
        content: [TextContent(text: 'User updated:\n${_encoder.convert(user)}')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to update user: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Delete User
  // ---------------------------------------------------------------------------

  final _deleteUserTool = Tool(
    name: 'delete_user',
    description: 'Delete a user by ID. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'id': Schema.int(description: 'The user ID to delete'),
      },
      required: ['id'],
    ),
  );

  FutureOr<CallToolResult> _handleDeleteUser(CallToolRequest request) async {
    try {
      final id = request.arguments!['id'] as int;
      await apiClient.deleteUser(id);
      return CallToolResult(
        content: [TextContent(text: 'User $id deleted successfully.')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to delete user: $e')],
        isError: true,
      );
    }
  }
}
