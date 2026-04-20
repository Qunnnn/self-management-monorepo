import '../entities/user.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<(User, AuthTokens)> execute({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty.');
    }
    if (password.isEmpty) {
      throw Exception('Password cannot be empty.');
    }

    return _repository.login(email: email, password: password);
  }
}
