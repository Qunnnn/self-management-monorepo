import 'package:dio/dio.dart';
import 'network_config.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';
import 'package:fpdart/fpdart.dart';
import '../error/failure.dart';

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

  Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ConnectionFailure();
      case DioExceptionType.badResponse:
        return ServerFailure(
          e.response?.statusMessage ?? 'Server Error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return const ConnectionFailure();
      default:
        return UnknownFailure(e.message ?? 'An unknown error occurred');
    }
  }

  Future<Either<Failure, T>> request<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
