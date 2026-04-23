import '../../../users/domain/entities/user.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthTokens>> execute({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty.'));
    }
    if (password.isEmpty) {
      return const Left(ValidationFailure('Password cannot be empty.'));
    }

    return _repository.login(email: email, password: password);
  }
}
