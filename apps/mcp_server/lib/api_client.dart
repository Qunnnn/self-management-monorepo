/// HTTP client wrapping the Self-Management backend API.
///
/// Manages authentication state (JWT token) and provides typed methods
/// for all backend endpoints.
library;

import 'package:dio/dio.dart';

/// A lightweight HTTP client for the Self-Management backend REST API.
///
/// Stores the JWT token after login and automatically attaches it to
/// subsequent requests via the Authorization header.
class ApiClient {
  ApiClient({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  final Dio _dio;
  String? _token;

  /// Whether the client currently holds a valid JWT token.
  bool get isAuthenticated => _token != null;

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// Authenticate with email/password. Stores the JWT token for future calls.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/login',
      data: {'email': email, 'password': password},
    );
    final data = response.data!;
    _token = data['accessToken'] as String?;
    return data;
  }

  // ---------------------------------------------------------------------------
  // Health
  // ---------------------------------------------------------------------------

  /// Returns `true` if the backend is reachable.
  Future<String> healthCheck() async {
    final response = await _dio.get<String>('/health');
    return response.data ?? 'OK';
  }

  // ---------------------------------------------------------------------------
  // Users
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> listUsers() async {
    final response = await _dio.get<List<dynamic>>(
      '/users',
      options: _authOptions(),
    );
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/$id',
      options: _authOptions(),
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/users',
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> updateUser(
    int id, {
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/users/$id',
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      },
      options: _authOptions(),
    );
    return response.data!;
  }

  Future<void> deleteUser(int id) async {
    await _dio.delete<void>('/users/$id', options: _authOptions());
  }

  // ---------------------------------------------------------------------------
  // Tasks
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> listTasks() async {
    final response = await _dio.get<List<dynamic>>(
      '/tasks',
      options: _authOptions(),
    );
    return response.data ?? [];
  }

  Future<List<dynamic>> listUserTasks(int userId) async {
    final response = await _dio.get<List<dynamic>>(
      '/users/$userId/tasks',
      options: _authOptions(),
    );
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> getTask(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/tasks/$id',
      options: _authOptions(),
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> createTask({
    required int userId,
    required String title,
    String? description,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/tasks',
      data: {
        'userId': userId,
        'title': title,
        if (description != null) 'description': description,
      },
      options: _authOptions(),
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> completeTask(int id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/tasks/$id/complete',
      options: _authOptions(),
    );
    return response.data!;
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete<void>('/tasks/$id', options: _authOptions());
  }

  // ---------------------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/stats',
      options: _authOptions(),
    );
    return response.data!;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Options _authOptions() {
    if (_token == null) {
      throw StateError(
        'Not authenticated. Call the login tool first to obtain a JWT token.',
      );
    }
    return Options(headers: {'Authorization': 'Bearer $_token'});
  }
}
