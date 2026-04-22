import 'package:fpdart/fpdart.dart';
import '../models/auth_tokens_model.dart';
import '../../../../core/network/index.dart';
import 'auth_api.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dioClient, this._api);
  final DioClient _dioClient;
  final AuthApi _api;

  Future<Either<Failure, AuthTokensModel>> login({
    required String email,
    required String password,
  }) async {
    return _dioClient.request(() async {
      final response = await _api.login({
        'email': email,
        'password': password,
      });

      return AuthTokensModel(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    });
  }
}
