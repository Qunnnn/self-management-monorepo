import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/network/index.dart';
import 'package:mobile/features/users/data/models/user_model.dart';
import 'package:mobile/features/users/data/data_sources/user_api.dart';

abstract class UserRemoteDataSource {
  Future<Either<Failure, UserModel>> fetchCurrentUser();
  Future<Either<Failure, void>> deleteAccount();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;
  final UserApi _api;

  UserRemoteDataSourceImpl(this._dioClient, this._api);

  @override
  Future<Either<Failure, UserModel>> fetchCurrentUser() async {
    return _dioClient.request(() async {
      return await _api.fetchCurrentUser();
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return _dioClient.request(() async {
      await _api.deleteAccount();
    });
  }
}
