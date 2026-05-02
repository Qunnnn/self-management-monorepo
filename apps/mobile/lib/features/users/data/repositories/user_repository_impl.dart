import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/users/domain/entities/user.dart';
import 'package:mobile/features/users/domain/repositories/user_repository.dart';
import 'package:mobile/features/users/data/data_sources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> fetchCurrentUser() async {
    return await _remoteDataSource.fetchCurrentUser();
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return await _remoteDataSource.deleteAccount();
  }
}
