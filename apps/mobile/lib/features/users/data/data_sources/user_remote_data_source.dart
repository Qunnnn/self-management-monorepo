
import 'package:mobile/core/import/app_imports.dart';
import 'package:mobile/features/users/domain/entities/user.dart' as entity;

abstract class UserRemoteDataSource {
  Future<Either<Failure, entity.User>> fetchCurrentUser();
  Future<Either<Failure, void>> deleteAccount();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;
  final DefaultApi _api;

  UserRemoteDataSourceImpl(this._dioClient, this._api);

  @override
  Future<Either<Failure, entity.User>> fetchCurrentUser() async {
    return _dioClient.request(() async {
      final response = await _api.usersIdGet(id: 'me');
      final data = response.data!;
      return entity.User(
        id: data.id ?? '',
        name: data.name ?? '',
        email: data.email ?? '',
        avatarUrl: null,
      );
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return _dioClient.request(() async {
      await _api.usersIdDelete(id: 'me');
    });
  }
}
