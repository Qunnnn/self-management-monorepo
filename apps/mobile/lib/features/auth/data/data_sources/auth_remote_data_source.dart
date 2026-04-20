import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';
import '../../../../core/network/index.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);
  final Dio _dio;

  Future<(UserModel, AuthTokensModel)> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      APIEndpoint.login.path,
      data: {
        'email': email,
        'password': password,
      },
    );

    final user = UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    final tokens = AuthTokensModel.fromJson(response.data['tokens'] as Map<String, dynamic>);
    return (user, tokens);
  }

  Future<UserModel?> fetchCurrentUser() async {
    final response = await _dio.get(APIEndpoint.profile.path);
    if (response.data == null) return null;
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
