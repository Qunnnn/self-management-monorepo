import 'package:dio/dio.dart';
import 'network_config.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

class DioClient {
  DioClient(TokenStorage tokenStorage) {
    _publicDio = Dio(BaseOptions(
      baseUrl: NetworkConfig.baseURL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ));
    _publicDio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    _dio = Dio(BaseOptions(
      baseUrl: NetworkConfig.baseURL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ));

    _dio.interceptors.add(AuthInterceptor(tokenStorage, _publicDio));
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  late final Dio _dio;
  late final Dio _publicDio;

  Dio get dio => _dio;
  Dio get publicDio => _publicDio;
}
