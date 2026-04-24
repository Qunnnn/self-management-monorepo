import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> fetchCurrentUser();
  Future<Either<Failure, void>> deleteAccount();
}
