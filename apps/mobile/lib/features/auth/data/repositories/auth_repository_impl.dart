import '../../../users/domain/entities/user.dart';
import '../../../users/domain/repositories/user_repository.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../../../../core/network/index.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;
  final UserRepository _userRepository;

  AuthRepositoryImpl(this._dataSource, this._tokenStorage, this._userRepository);

  @override
  Future<Either<Failure, (User, AuthTokens)>> login({
    required String email,
    required String password,
  }) async {
    final loginResult = await _dataSource.login(
      email: email,
      password: password,
    );

    return loginResult.match(
      (failure) => Left(failure),
      (tokensModel) async {
        final tokens = tokensModel.toEntity();
        await _tokenStorage.saveTokens(tokens);

        // Fetch user profile after saving tokens using the dedicated UserRepository
        final userResult = await _userRepository.fetchCurrentUser();
        return userResult.match(
          (failure) => Left(failure),
          (user) {
            return Right((user, tokens));
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _tokenStorage.clearTokens();
    return const Right(null);
  }
}
