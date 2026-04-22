import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mobile/features/users/data/models/user_model.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET('/users/me')
  Future<UserModel> fetchCurrentUser();
}
