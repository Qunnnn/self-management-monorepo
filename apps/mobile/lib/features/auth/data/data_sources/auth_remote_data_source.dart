import 'package:fpdart/fpdart.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';
import '../../../../core/network/index.dart';
import 'auth_api.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dioClient, this._api);
  final DioClient _dioClient;
  final AuthApi _api;

  Future<Either<Failure, (UserModel, AuthTokensModel)>> login({
    required String email,
    required String password,
  }) async {
    return _dioClient.request(() async {
      final response = await _api.login({
        'email': email,
        'password': password,
      });

      return (response.user, response.tokens);
    });
  }

  Future<Either<Failure, UserModel?>> fetchCurrentUser() async {
    return _dioClient.request(() async {
      final user = await _api.fetchCurrentUser();
      return user;
    });
  }
}
