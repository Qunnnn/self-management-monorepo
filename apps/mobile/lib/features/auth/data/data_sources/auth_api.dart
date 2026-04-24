import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/login_response_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponseModel> login(@Body() Map<String, dynamic> body);
}
