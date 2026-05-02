/// MCP tool definitions for task management.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import '../api_client.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// Registers task-related MCP tools (list, get, create, complete, delete).
base mixin TaskTools on MCPServer, ToolsSupport {
  /// The shared API client — must be provided by the composing server.
  ApiClient get apiClient;

  /// Call this from the server constructor to register all task tools.
  void registerTaskTools() {
    registerTool(_listTasksTool, _handleListTasks);
    registerTool(_listUserTasksTool, _handleListUserTasks);
    registerTool(_getTaskTool, _handleGetTask);
    registerTool(_createTaskTool, _handleCreateTask);
    registerTool(_completeTaskTool, _handleCompleteTask);
    registerTool(_deleteTaskTool, _handleDeleteTask);
  }

  // ---------------------------------------------------------------------------
  // List Tasks
  // ---------------------------------------------------------------------------

  final _listTasksTool = Tool(
    name: 'list_tasks',
    description: 'List all tasks across all users. Requires authentication.',
    inputSchema: Schema.object(properties: {}),
  );

  FutureOr<CallToolResult> _handleListTasks(CallToolRequest request) async {
    try {
      final tasks = await apiClient.listTasks();
      return CallToolResult(
        content: [TextContent(text: _encoder.convert(tasks))],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to list tasks: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // List User Tasks
  // ---------------------------------------------------------------------------

  final _listUserTasksTool = Tool(
    name: 'list_user_tasks',
    description:
        'List all tasks for a specific user. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'userId': Schema.int(description: 'The user ID to list tasks for'),
      },
      required: ['userId'],
    ),
  );

  FutureOr<CallToolResult> _handleListUserTasks(
    CallToolRequest request,
  ) async {
    try {
      final userId = request.arguments!['userId'] as int;
      final tasks = await apiClient.listUserTasks(userId);
      return CallToolResult(
        content: [TextContent(text: _encoder.convert(tasks))],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to list user tasks: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Get Task
  // ---------------------------------------------------------------------------

  final _getTaskTool = Tool(
    name: 'get_task',
    description: 'Get a specific task by ID. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'id': Schema.int(description: 'The task ID'),
      },
      required: ['id'],
    ),
  );

  FutureOr<CallToolResult> _handleGetTask(CallToolRequest request) async {
    try {
      final id = request.arguments!['id'] as int;
      final task = await apiClient.getTask(id);
      return CallToolResult(
        content: [TextContent(text: _encoder.convert(task))],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to get task: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Create Task
  // ---------------------------------------------------------------------------

  final _createTaskTool = Tool(
    name: 'create_task',
    description: 'Create a new task for a user. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'userId': Schema.int(description: 'The user ID who owns this task'),
        'title': Schema.string(description: 'Title of the task'),
        'description': Schema.string(
          description: 'Optional description of the task',
        ),
      },
      required: ['userId', 'title'],
    ),
  );

  FutureOr<CallToolResult> _handleCreateTask(CallToolRequest request) async {
    try {
      final args = request.arguments!;
      final task = await apiClient.createTask(
        userId: args['userId'] as int,
        title: args['title'] as String,
        description: args['description'] as String?,
      );
      return CallToolResult(
        content: [
          TextContent(text: 'Task created:\n${_encoder.convert(task)}'),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to create task: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Complete Task
  // ---------------------------------------------------------------------------

  final _completeTaskTool = Tool(
    name: 'complete_task',
    description:
        'Mark a task as completed. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'id': Schema.int(description: 'The task ID to mark as completed'),
      },
      required: ['id'],
    ),
  );

  FutureOr<CallToolResult> _handleCompleteTask(
    CallToolRequest request,
  ) async {
    try {
      final id = request.arguments!['id'] as int;
      final task = await apiClient.completeTask(id);
      return CallToolResult(
        content: [
          TextContent(text: 'Task completed:\n${_encoder.convert(task)}'),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to complete task: $e')],
        isError: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Delete Task
  // ---------------------------------------------------------------------------

  final _deleteTaskTool = Tool(
    name: 'delete_task',
    description: 'Delete a task by ID. Requires authentication.',
    inputSchema: Schema.object(
      properties: {
        'id': Schema.int(description: 'The task ID to delete'),
      },
      required: ['id'],
    ),
  );

  FutureOr<CallToolResult> _handleDeleteTask(CallToolRequest request) async {
    try {
      final id = request.arguments!['id'] as int;
      await apiClient.deleteTask(id);
      return CallToolResult(
        content: [TextContent(text: 'Task $id deleted successfully.')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to delete task: $e')],
        isError: true,
      );
    }
  }
}
