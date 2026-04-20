import '../../../../core/network/index.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, this._tokenStorage);

  final AuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<(User, AuthTokens)> login({
    required String email,
    required String password,
  }) async {
    final (userModel, tokensModel) = await _dataSource.login(
      email: email,
      password: password,
    );

    final user = userModel.toEntity();
    final tokens = tokensModel.toEntity();

    await _tokenStorage.saveTokens(tokens);

    return (user, tokens);
  }

  @override
  Future<User?> fetchCurrentUser() async {
    final userModel = await _dataSource.fetchCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
