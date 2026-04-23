import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../../../../core/network/index.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._dataSource, this._tokenStorage);

  @override
  Future<Either<Failure, AuthTokens>> login({
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
        return Right(tokens);
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _tokenStorage.clearTokens();
    return const Right(null);
  }
}
