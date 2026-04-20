import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';

class AuthMockDataSource {
  Future<(UserModel, AuthTokensModel)> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'test@example.com' && password == 'password') {
      final user = UserModel(
        id: '1',
        email: email,
        name: 'John Doe',
      );
      final tokens = AuthTokensModel(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
      );
      return (user, tokens);
    } else {
      throw Exception('Invalid email or password.');
    }
  }

  Future<UserModel?> fetchCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'John Doe',
    );
  }
}
