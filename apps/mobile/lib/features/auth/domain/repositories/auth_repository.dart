import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<(User, AuthTokens)> login({
    required String email,
    required String password,
  });

  Future<User?> fetchCurrentUser();
  
  Future<void> logout();
}
