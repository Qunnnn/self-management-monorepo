import 'package:dio/dio.dart';
import 'token_storage.dart';
import 'api_endpoint.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._refreshDio);

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Check if the current path is public
    final isPublic = APIEndpoint.values.any(
      (e) => e.path == options.path && e.isPublic,
    );

    if (!isPublic) {
      final tokens = await _tokenStorage.loadTokens();
      if (tokens != null) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Logic for token refresh would go here
    }
    handler.next(err);
  }
}
