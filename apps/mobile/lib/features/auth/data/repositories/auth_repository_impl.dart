import '../../../../core/network/index.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, this._tokenStorage);

  final AuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<Either<Failure, (User, AuthTokens)>> login({
    required String email,
    required String password,
  }) async {
    final result = await _dataSource.login(
      email: email,
      password: password,
    );

    return result.match(
      (failure) => Left(failure),
      (data) async {
        final (userModel, tokensModel) = data;
        final user = userModel.toEntity();
        final tokens = tokensModel.toEntity();
        await _tokenStorage.saveTokens(tokens);
        return Right((user, tokens));
      },
    );
  }

  @override
  Future<Either<Failure, User?>> fetchCurrentUser() async {
    final result = await _dataSource.fetchCurrentUser();
    return result.map((userModel) => userModel?.toEntity());
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _tokenStorage.clearTokens();
    return const Right(null);
  }
}
