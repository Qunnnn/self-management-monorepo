sealed class APIError implements Exception {
  const APIError(this.message);
  final String message;
}

class InvalidURL extends APIError {
  const InvalidURL() : super('Invalid URL constructed.');
}

class RequestFailed extends APIError {
  const RequestFailed(Object error) : super('Network request failed: $error');
}

class InvalidResponse extends APIError {
  const InvalidResponse() : super('Received invalid response from server.');
}

class StatusCode extends APIError {
  const StatusCode(this.code) : super('HTTP Error: $code');
  final int code;
}

class DecodingFailed extends APIError {
  const DecodingFailed(Object error) : super('Failed to decode response: $error');
}
