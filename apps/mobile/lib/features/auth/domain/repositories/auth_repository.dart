import '../entities/user.dart';
import '../entities/auth_tokens.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

abstract class AuthRepository {
  Future<Either<Failure, (User, AuthTokens)>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User?>> fetchCurrentUser();
  
  Future<Either<Failure, void>> logout();
}
