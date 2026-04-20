import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_mock_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthMockDataSource _dataSource;
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override
  Future<(User, AuthTokens)> login({
    required String email,
    required String password,
  }) async {
    final (userModel, tokensModel) = await _dataSource.login(
      email: email,
      password: password,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, tokensModel.accessToken);
    await prefs.setString(_refreshTokenKey, tokensModel.refreshToken);

    return (userModel.toEntity(), tokensModel.toEntity());
  }

  @override
  Future<User?> fetchCurrentUser() async {
    final userModel = await _dataSource.fetchCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
