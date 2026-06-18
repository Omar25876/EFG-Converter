abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  const NoInternetException()
      : super('No internet connection', statusCode: 0);
}

class TimeoutExceptionApi extends ApiException {
  const TimeoutExceptionApi()
      : super('Request timed out', statusCode: 408);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException()
      : super('Unauthorized — please login again', statusCode: 401);
}

class ServerException extends ApiException {
  const ServerException()
      : super('Server error, please try again later', statusCode: 500);
}

class NetworkException extends ApiException {
  const NetworkException()
      : super('Network error, please try again later', statusCode: 0);
}

class BadRequestException extends ApiException {
  const BadRequestException([String? msg])
      : super(msg ?? 'Bad request', statusCode: 400);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
}