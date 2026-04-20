sealed class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure() : super('No Internet Connection');
}

class DecodingFailure extends Failure {
  const DecodingFailure(Object error) : super('Failed to decode response: $error');
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}
