import 'package:fpdart/fpdart.dart';
import 'package:mobile/features/auth/domain/entities/auth_tokens.dart';
import '../../../../core/network/index.dart';
import 'package:api_client/api_client.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dioClient, this._api);
  final DioClient _dioClient;
  final DefaultApi _api;

  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    return _dioClient.request(() async {
      final response = await _api.authLoginPost(
        loginRequest: LoginRequest(email: email, password: password),
      );
      final data = response.data!;
      return AuthTokens(
        accessToken: data.accessToken ?? '',
        refreshToken: data.refreshToken ?? '',
      );
    });
  }
}
